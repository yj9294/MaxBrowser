//
//  TabView.swift
//  MaxBrowser
//
//  Created by yangjian on 2023/5/23.
//

import SwiftUI

struct TabView: View {
    
    @EnvironmentObject var store: AppStore
    
    let colums:[GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    var browsers: [Browser] {
        store.state.home.browsers
    }
    
    var browser: Browser {
        store.state.home.browser
    }

    var body: some View {
        VStack{
            ScrollView{
                LazyVGrid(columns: colums) {
                    ForEach(browsers, id: \.self) { browser in
                        Button {
                            select(browser: browser)
                        } label: {
                            VStack{
                                HStack{
                                    Spacer()
                                    Button {
                                        delete(browser: browser)
                                    } label: {
                                        Image("tab_close")

                                    }.padding(.trailing, 10).padding(.top, 5).opacity(browsers.count == 1 ? 0 : 1)
                                }
                                Image("launch_icon")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                if browser.isNavigation {
                                    Text("Navigation")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .padding(.top, 20)
                                } else {
                                    let url = browser.webView.url?.absoluteString ?? ""
                                    Text(url)
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .padding(.top, 20)
                                        .padding(.horizontal, 10)
                                }
                                
                                HStack {
                                    Spacer()
                                }
                            }
                        }.padding(.bottom,40).background(Color(browser.isSelect ? "#70C4AA" : "#9DDAC6").cornerRadius(8))
                    }
                }
                .padding(.all, 16)
                Spacer()
            }
            
            VStack{
                ZStack {
                    HStack{
                        Button(action: back) {
                            Image("tab_back")
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    Button(action: add) {
                        Image("tab_add")
                    }
                }
            }
            .frame(height: 66)
            
        }.background(Image("launch_background").resizable().scaledToFill().ignoresSafeArea()).onAppear{
            store.dispatch(.logEvent(.tabShow))
        }
    }
}

extension TabView {
    
    func select(browser: Browser) {
        store.dispatch(.select(browser))
        store.dispatch(.addBrowserObservable)
        store.dispatch(.dismiss)
    }
    
    func delete(browser: Browser) {
        store.dispatch(.delete(browser))
        store.dispatch(.addBrowserObservable)
        store.dispatch(.dismiss)
    }
    
    func add() {
        store.dispatch(.newBrowser)
        store.dispatch(.addBrowserObservable)
        store.dispatch(.dismiss)
        
        store.dispatch(.logEvent(.browserNew, ["bro": "tab"]))
    }
    
    func back() {
        store.dispatch(.addBrowserObservable)
        store.dispatch(.dismiss)
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView().environmentObject(AppStore())
    }
}
