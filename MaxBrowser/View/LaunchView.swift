//
//  LaunchView.swift
//  MaxBrowser
//
//  Created by yangjian on 2023/5/23.
//

import SwiftUI

struct LaunchView: View {
    
    @State var progress = 0.0
    
    var launched: (()->Void)? = nil
    
    var body: some View {
        VStack(spacing: 334){
            VStack(spacing: 21){
                Image("launch_icon")
                Image("launch_title")
            }
            HStack{
                ProgressView(value: progress, total: 1.0).accentColor(Color("#25C384")).background(Color.clear).padding(.horizontal, 4)
            }.background(Image("launch_progress_background").resizable().scaledToFill()).padding(.horizontal, 70)
        }.background(Image("launch_background").ignoresSafeArea()).onAppear{
            debugPrint("launching 出现了")
            viewDidLoad()
        }
    }
}

extension LaunchView {
    
    func viewDidLoad() {
        let token = SubscriptionToken()
        let duration = 3.0
        let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
        timer.sink { _ in
            let progress = progress + 0.01 / duration
            if progress > 1.0 {
                launched?()
                token.unseal()
            } else {
                self.progress = progress
            }
        }.seal(in: token)
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
