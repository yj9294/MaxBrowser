//
//  HomeView.swift
//  MaxBrowser
//
//  Created by yangjian on 2023/5/23.
//

import SwiftUI
import AppTrackingTransparency
import IQKeyboardManagerSwift

struct HomeView: View {
    
    @EnvironmentObject var store: AppStore
    
    // 为了刷新webview
    @State var tabShow: Bool = false
    
    let columns:[GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        
    var text: String {
        store.state.home.text
    }
    
    var isPlaceholder:  Bool {
        store.state.home.text.count == 0
    }
    
    var isLoading: Bool {
        store.state.home.isLoading
    }
    
    var canGoBack: Bool {
        store.state.home.canGoBack
    }
    
    var canGoForword: Bool {
        store.state.home.canGoForword
    }
    
    var itemCount: Int {
        store.state.home.browsers.count
    }
    
    var isNavigation: Bool {
        store.state.home.browser.isNavigation
    }
    
    var browser: Browser {
        store.state.home.browser
    }
    
    var body: some View {
        
        GeometryReader { _ in
            VStack{
                VStack{
                    HStack{
                        TextField("", text: $store.state.home.text).placeholder(when: isPlaceholder) {
                            Text("Search web…").font(.system(size: 14.0)).foregroundColor(Color("#9DDAC6"))
                        }.padding(.horizontal, 16)
                        Button(action: {
                            !isLoading ? search() : stopSearch()
                        }, label: {
                            ZStack {
                                Color("#70C4AA").frame(width: 52, height: 52)
                                Image(isLoading ? "close" : "home_search")
                            }
                        })
                    }.cornerRadius(8).frame(height: 52).background(Image("home_search_background").resizable().scaledToFill())
                }.padding(.horizontal, 24).padding(.top, 30)
                
                if isLoading {
                    HStack{
                        ProgressView(value: 0.5, total: 1.0).accentColor(Color("#36CF97")).frame(height: 2)
                    }.padding(.top, 10)
                }
                
                VStack{
                    if isNavigation {
                        Image("launch_icon").padding(.top, 60)
                        LazyVGrid(columns: columns, spacing: 20){
                            ForEach(HomeState.Index.allCases, id: \.self) { index in
                                Button(action: {
                                    searchIndex(index)
                                }, label: {
                                    VStack{
                                        Image(index.icon)
                                        Text(index.title)
                                            .foregroundColor(Color("#333333"))
                                            .font(.system(size: 13.0))
                                    }
                                })
                            }
                        }.padding(.horizontal, 16).padding(.top, 40)
                    } else if !tabShow {
                        WebView(webView: browser.webView)
                    }
                }
                Spacer()
                
                HStack{
                    Button(action: back) {
                        Image(canGoBack ? "left" : "left_1")
                    }
                    Spacer()
                    Button(action: forword) {
                        Image(canGoForword ? "right" : "right_1")
                    }
                    Spacer()
                    Button(action: clean) {
                        Image("clean")
                    }
                    Spacer()
                    Button(action: tab) {
                        ZStack {
                            Image("tab")
                            Text("\(itemCount)")
                                .font(.system(size: 12))
                                .foregroundColor(Color("#455552"))
                        }
                    }
                    Spacer()
                    Button(action: setting) {
                        Image("setting")
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            }.background(Image("launch_background").resizable().scaledToFill().ignoresSafeArea()).onAppear{
                viewDidLoad()
        }
        }
    }
}

extension HomeView {
    
    func viewDidLoad() {
        tabShow = false
        IQKeyboardManager.shared.enable = true
        store.dispatch(.logEvent(.homeShow))
        Task{
            if !Task.isCancelled {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                ATTrackingManager.requestTrackingAuthorization { _ in
                }
            }
        }
    }
    
    func search() {
        store.dispatch(.hiddenKeyboard)
        if text == "" {
            store.dispatch(.alert("Please enter your search content."))
            return
        }
        store.state.home.isLoading = true
        store.dispatch(.load(text))
        store.dispatch(.addBrowserObservable)
        
        store.dispatch(.logEvent(.homeClickSearch, ["bro": text]))
    }
    
    func stopSearch() {
        browser.stopLoad()
        store.state.home.text = ""
        store.state.home.isLoading = false
    }
    
    func searchIndex(_ index: HomeState.Index) {
        store.dispatch(.hiddenKeyboard)
        store.state.home.isLoading = true
        store.dispatch(.load(index.url))
        store.dispatch(.addBrowserObservable)
        
        store.dispatch(.logEvent(.homeClickButton, ["bro": index.rawValue]))
    }
    
    func back() {
        browser.goBack()
    }
    
    func forword() {
        browser.goForword()
    }
    
    func clean() {
        store.dispatch(.present(AnyView(CleanSelectView().environmentObject(store)), .overCurrentContext))
        store.dispatch(.logEvent(.homeClickClean))
    }
    
    func tab() {
        tabShow = true
        store.dispatch(.present(AnyView(TabView().environmentObject(store)), .fullScreen))
    }
    
    func setting() {
        store.dispatch(.present(AnyView(SettingView().environmentObject(store)), .overCurrentContext))
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(AppStore())
    }
}
