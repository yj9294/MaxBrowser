//
//  CleanView.swift
//  MaxBrowser
//
//  Created by yangjian on 2023/5/24.
//

import SwiftUI

struct CleanView: View {
    
    @State var isAnimation = false
    
    @EnvironmentObject var store: AppStore

    var body: some View {
        VStack{
            ZStack{
                Image("clean_bg").rotationEffect(Angle(degrees: isAnimation ? 360.0 : 0.0)).animation(.linear(duration: 3), value: isAnimation)
                Image("clean_icon")
            }.padding(.top, 180)
            Text("Cleaning...")
            Spacer()
            HStack{Spacer()}
        }.background(Image("launch_background").resizable().scaledToFit().ignoresSafeArea()).onAppear{
            isAnimation = true
            Task{
                if !Task.isCancelled {
                    try await Task.sleep(nanoseconds: 2_000_000_000)
                    store.dispatch(.clean)
                    store.dispatch(.addBrowserObservable)
                    
                    store.dispatch(.logEvent(.cleanAnimationCompletion))
                    
                    store.dispatch(.dismiss)
                    store.dispatch(.alert("Cleaned"))
                    store.dispatch(.logEvent(.cleanCompletionAlertShow))
                }
            }
        }
    }
}

struct CleanView_Previews: PreviewProvider {
    static var previews: some View {
        CleanView()
    }
}
