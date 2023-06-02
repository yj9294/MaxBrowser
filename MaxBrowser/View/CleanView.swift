//
//  CleanView.swift
//  MaxBrowser
//
//  Created by yangjian on 2023/5/24.
//

import SwiftUI

struct CleanView: View {
    
    @State var isAnimation = false
    
    @State var closeAD = false
    
    @EnvironmentObject var store: AppStore

    var body: some View {
        VStack{
            ZStack{
                Image("clean_bg").rotationEffect(Angle(degrees: isAnimation ? 360.0 * 5 : 0.0)).animation(.linear(duration: 15), value: isAnimation)
                Image("clean_icon")
            }.padding(.top, 180)
            Text("Cleaning...")
            Spacer()
            HStack{Spacer()}
        }.background(Image("launch_background").resizable().scaledToFit().ignoresSafeArea()).onAppear{
            isAnimation = true
            if !closeAD {
                viewDidLoad()
            }
        }
    }
    
    func viewDidLoad() {
        let token = SubscriptionToken()
        var duration = 15.0
        var pro = 0.0
        let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
        timer.sink { _ in
            let progress = pro + 0.01 / duration
            if progress > 1.0 {
                closeAD = true
                store.dispatch(.adShow(.interstitial) { _ in
                    cleaned()
                })
                token.unseal()
            } else {
                pro = progress
            }
            if progress > 0.3,
               store.state.ad.isLoaded(.interstitial) {
                duration = 0.1
            }
        }.seal(in: token)
        
        store.dispatch(.adLoad(.interstitial))
        store.dispatch(.adLoad(.native))
    }
    
    func cleaned() {
        store.dispatch(.clean)
        store.dispatch(.addBrowserObservable)
        
        store.dispatch(.logEvent(.cleanAnimationCompletion))
        
        store.dispatch(.dismiss)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            store.dispatch(.alert("Cleaned"))
        }
        store.dispatch(.logEvent(.cleanCompletionAlertShow))
    }
}

struct CleanView_Previews: PreviewProvider {
    static var previews: some View {
        CleanView()
    }
}
