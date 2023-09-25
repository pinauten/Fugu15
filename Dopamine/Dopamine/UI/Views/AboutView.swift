//
//  AboutView.swift
//  Evyrest
//
//  Created by Lakhan Lothiyi on 30/12/2022.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.openURL) var openURL
    @State var easterEgg = false
    
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    let contributors = [
        ("opa334", "http://github.com/opa334"),
        ("Évelyne", "http://github.com/evelyneee"),
        ("sourcelocation", "http://github.com/sourcelocation"),
        ("Linus Henze", "http://github.com/LinusHenze"),
        ("Cryptic", "http://github.com/Cryptiiiic"),
        ("Clarity", "http://github.com/TheRealClarity"),
        ("Dhinakg", "http://github.com/dhinakg"),
        ("Capt Inc", "http://github.com/captinc"),
        ("Sam Bingner", "http://github.com/sbingner"),
        ("ProcursusTeam", "http://github.com/ProcursusTeam"),
        ("kirb", "http://github.com/kirb"),
        ("Amy While", "http://github.com/elihwyma"),
    ]
    
    var body: some View {
        VStack {
            VStack {
                Button(action: {
                    openURL(URL(string: "https://github.com/opa334/Dopamine")!)
                }) {
                    HStack {
                        Spacer()
                        Image("github")
                        Text("Credits_Button_Source_Code")
                        Spacer()
                    }
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.25), lineWidth: 0.5)
                    )
                    .padding(.horizontal, 32)
                }
                Button(action: {
                    openURL(URL(string: "https://github.com/opa334/Dopamine/LICENSE.md")!)
                }) {
                    HStack {
                        Spacer()
                        Image(systemName: "scroll")
                        Text("Credits_Button_License")
                        Spacer()
                    }
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.25), lineWidth: 0.5)
                    )
                    .padding(.horizontal, 32)
                }
                Button(action: {
                    openURL(URL(string: "https://discord.gg/jb")!)
                }) {
                    HStack {
                        Spacer()
                        Image("discord")
                        Text("Credits_Button_Discord")
                        Spacer()
                    }
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.25), lineWidth: 0.5)
                    )
                    .padding(.horizontal, 32)
                }
            }
            .padding(.vertical)
            
            LazyVGrid(columns: columns) {
                ForEach(contributors, id: \.0) { contributor in
                    Link(destination: URL(string: contributor.1)!) {
                        HStack {
                            Text(contributor.0)
                            Image(systemName: Locale.characterDirection(forLanguage: Locale.current.languageCode ?? "") == .rightToLeft ? "chevron.left" : "chevron.right")
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .font(.footnote)
            .opacity(0.6)
            .padding(.bottom)
            .padding(.horizontal, 16)
            
            
            Text("Credits_Header_Special_Thanks")
                .fixedSize()
                .font(.footnote)
                .opacity(0.6)
            
            HStack(spacing: 12) {
                Button {
                    openURL(URL(string: "https://github.com/pinauten/Fugu15")!)
                } label: {
                    Image("FuguTransparent")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 24)
                        .opacity(0.5)
                }
                
                Button {
                    openURL(URL(string: "https://pinauten.de/")!)
                } label: {
                    Image("PinautenLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 24)
                        .opacity(0.5)
                }
            }
            .padding(.bottom)
            Group {
                if !easterEgg {
                    Text("Credits_Footer_Dopamine_Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")\nOS:\(ProcessInfo.processInfo.operatingSystemVersionString)")
                } else {
                    Text(verbatim: "Wait, it's all Evyrest?\nAlways has been.")
                }
            }
            .fixedSize()
            .font(.footnote)
            .opacity(0.6)
            .onTapGesture(count: 5) {
                easterEgg.toggle()
            }
        }
        .foregroundColor(.white)
        .multilineTextAlignment(.center)
//        .frame(maxHeight: 600)
    }
}


struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        JailbreakView()
    }
}
