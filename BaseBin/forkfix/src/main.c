#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <signal.h>
#include <dlfcn.h>
#include <os/log.h>
#include "syscall.h"
#include "litehook.h"

extern int64_t jbdswForkFix(pid_t childPid);
extern void _malloc_fork_prepare(void);
extern void _malloc_fork_parent(void);
extern void xpc_atfork_prepare(void);
extern void xpc_atfork_parent(void);
extern void dispatch_atfork_prepare(void);
extern void dispatch_atfork_parent(void);
extern void __fork(void);

int childToParentPipe[2];
int parentToChildPipe[2];
static void openPipes(void)
{
	if (pipe(parentToChildPipe) < 0 || pipe(childToParentPipe) < 0) {
		abort();
	}
}
static void closePipes(void)
{
	if (ffsys_close(parentToChildPipe[0]) != 0 || ffsys_close(parentToChildPipe[1]) != 0 || ffsys_close(childToParentPipe[0]) != 0 || ffsys_close(childToParentPipe[1]) != 0) {
		abort();
	}
}

void child_fixup(void)
{
	// Tell parent we are waiting for fixup now
	char msg = ' ';
	ffsys_write(childToParentPipe[1], &msg, sizeof(msg));

	// Wait until parent completes fixup
	ffsys_read(parentToChildPipe[0], &msg, sizeof(msg));
}

void parent_fixup(pid_t childPid)
{
	// Reenable some system functionality that XPC is dependent on and XPC itself
	// (Normally unavailable during __fork)
	_malloc_fork_parent();
	dispatch_atfork_parent();
	xpc_atfork_parent();

	// Wait until the child is ready and waiting
	char msg = ' ';
	read(childToParentPipe[0], &msg, sizeof(msg));

	// Child is waiting for wx_allowed + permission fixups now
	// Apply fixup
	int64_t fix_ret = jbdswForkFix(childPid);
	if (fix_ret != 0) {
		kill(childPid, SIGKILL);
		abort();
	}

	// Tell child we are done, this will make it resume
	write(parentToChildPipe[1], &msg, sizeof(msg));

	// Disable system functionality related to XPC again
	_malloc_fork_prepare();
	dispatch_atfork_prepare();
	xpc_atfork_prepare();
}

__attribute__((visibility ("default"))) pid_t forkfix___fork(void)
{
	openPipes();

	pid_t pid = ffsys_fork();
	if (pid < 0) {
		closePipes();
		return pid;
	}

	if (pid == 0) {
		child_fixup();
	}
	else {
		parent_fixup(pid);
	}

	closePipes();
	return pid;
}

__attribute__((constructor)) static void initializer(void)
{
	litehook_hook_function((void *)&__fork, (void *)&forkfix___fork);
}