//
//  LaunchView.swift
//  MaxBrowser
//
//  Created by yangjian on 2023/5/23.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var store: AppStore
        
    @State var closeAD = false
    
    var launched: (()->Void)? = nil
    
    var body: some View {
        VStack(spacing: 334){
            VStack(spacing: 21){
                Image("launch_icon")
                Image("launch_title")
            }
            HStack{
                ProgressView(value: store.state.tabbar.progress, total: 1.0).accentColor(Color("#25C384")).background(Color.clear).padding(.horizontal, 4).onAppear {
                    viewDidLoad()
                }
            }.background(Image("launch_progress_background").resizable().scaledToFill()).padding(.horizontal, 70)
        }.background(Image("launch_background").ignoresSafeArea()).onAppear{
            debugPrint("launching 出现了")
        }
    }
}

extension LaunchView {
    
    func viewDidLoad() {
        if closeAD {
            return
        }
        
        let token = SubscriptionToken()
        var duration = 15.0
        store.state.tabbar.progress = 0.0
        
        let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
        timer.sink { _ in
            let progress = store.state.tabbar.progress + 0.01 / duration
            if progress > 1.0 {
                store.dispatch(.adShow(.interstitial) { _ in
                    if store.state.tabbar.progress > 0.9 {
                        closeAD = true
                        self.launched?()
                    }
                })
                token.unseal()
            } else {
                store.state.tabbar.progress = progress
            }
            if progress > 0.3,
               store.state.ad.isLoaded(.interstitial) {
                duration = 1.0
            }
        }.seal(in: token)
        
        store.dispatch(.adLoad(.interstitial))
        store.dispatch(.adLoad(.native))
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView().environmentObject(AppStore())
    }
}
