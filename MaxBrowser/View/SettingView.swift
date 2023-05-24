//
//  SettingView.swift
//  MaxBrowser
//
//  Created by yangjian on 2023/5/24.
//

import SwiftUI

struct SettingView: View {
    
    @Environment(\.openURL) private var openURL
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        VStack{
            Spacer()
            VStack(spacing: 18){
                HStack(spacing: 46){
                    Button(action: new) {
                        SettingRow(index: .new)
                    }
                    Button(action: share) {
                        SettingRow(index: .share)
                    }
                    Button(action: copy) {
                        SettingRow(index: .copy)
                    }
                }.padding(.top, 24).padding(.horizontal, 38)
                Button(action: rate) {
                    SettingRow(index: .rate)
                }
                Button(action: terms) {
                    SettingRow(index: .terms)
                }
                Button(action: privacy) {
                    SettingRow(index: .privacy)
                }
            }.padding(.bottom, 20).background(Color.white.cornerRadius(10)).padding(.horizontal, 36)
            Spacer()
            HStack{
                Spacer()
            }
        }.background(Color.black.opacity(0.7).ignoresSafeArea().onTapGesture {
            dismiss()
        })
    }
}

extension SettingView {
    
    enum Index: String {
        case new, share, copy, rate, terms, privacy
        var title: String {
            switch self {
            case .rate:
                return "Rate us"
            case .terms:
                return "Terms of Users"
            case .privacy:
                return "Privacy Policy"
            default:
                return self.rawValue.capitalized
            }
        }
        var icon: String {
            return "setting_\(self)"
        }
    }
    
    struct SettingRow: View {
        let index: Index
        var body: some View {
            if index == .copy || index == .share || index == .new{
                VStack{
                    Image(index.icon)
                    Text(index.title).font(.system(size: 14.0)).foregroundColor(Color("#333333"))
                }
            } else {
                HStack{
                    Text(index.title).font(.system(size: 14.0)).foregroundColor(Color("#333333"))
                    Spacer()
                    Image("setting_arrow")
                }.modifier(SettingRowModifier())
            }
        }
        
        struct SettingRowModifier: ViewModifier {
            func body(content: Content) -> some View {
                content.frame(height: 40).padding(.horizontal, 28).background(Color("#D5F4E9").cornerRadius(5)).padding(.horizontal, 38)
            }
        }
    }
}

extension SettingView {
    
    func new() {
        store.dispatch(.newBrowser)
        store.dispatch(.addBrowserObservable)
        store.dispatch(.dismiss)
        
        store.dispatch(.logEvent(.browserNew, ["bro": "setting"]))
    }
    
    func share() {
        store.dispatch(.dismiss)
        let url = store.state.home.browser.webView.url?.absoluteString ?? "https://itunes.apple.com/cn/app/id6449425400"
        store.dispatch(.present(AnyView(ShareView(url: url)), .automatic))
        
        store.dispatch(.logEvent(.shareClick))
    }
    
    func copy() {
        store.dispatch(.dismiss)
        store.dispatch(.copy)
        
        store.dispatch(.logEvent(.copyClick))
    }
    
    func rate() {
        store.dispatch(.dismiss)
        if let url = URL(string: "https://itunes.apple.com/cn/app/id6449425400") {
            openURL(url)
        }
    }
    
    func terms() {
        store.dispatch(.dismiss)
        store.dispatch(.present(AnyView(PrivacyView(index: .terms).environmentObject(store)), .fullScreen))
    }
    
    func privacy() {
        store.dispatch(.dismiss)
        store.dispatch(.present(AnyView(PrivacyView(index: .privacy).environmentObject(store)), .fullScreen))
    }
    
    func dismiss() {
        store.dispatch(.dismiss)
    }
}


struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
