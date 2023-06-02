//
//  ContentView.swift
//  MaxBrowser
//
//  Created by yangjian on 2023/5/23.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var store: AppStore
    
    var isLaunch: Bool {
        store.state.tabbar.index == .launch
    }
    
    var body: some View {
        VStack {
            if isLaunch {
                LaunchView {
                    store.dispatch(.launched)
                }
            } else {
                HomeView()
            }
        }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            store.dispatch(.dismiss)
            store.dispatch(.luanching)
            store.dispatch(.logEvent(.openHot))
        }.onReceive(NotificationCenter.default.publisher(for: .nativeAdLoadCompletion)) { ad in
            if let ad = ad.object as? NativeViewModel {
                store.dispatch(.adModel(ad))
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppStore())
    }
}
