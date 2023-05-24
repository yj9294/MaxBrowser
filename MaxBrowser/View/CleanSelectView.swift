//
//  CleanSelectView.swift
//  MaxBrowser
//
//  Created by yangjian on 2023/5/24.
//

import SwiftUI

struct CleanSelectView: View {
    
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        VStack{
            Spacer()
            VStack{                Image("clean_icon").padding(.top, 20)
                Text("Close Tabs and Clear Data").foregroundColor(Color("#A4A4A4")).font(.system(size: 14.0)).padding(.bottom, 11)
                HStack{
                    Button(action: dismiss) {
                        Text("Cancel").font(.system(size: 12.0))
                    }.padding(.vertical, 12).padding(.horizontal, 36).background(Color("#D9E1DE").cornerRadius(20))
                    Spacer()
                    Button(action: confirm) {
                        Text("Confirm").font(.system(size: 12))
                    }.padding(.vertical, 12).padding(.horizontal, 36).foregroundColor(Color.white).background(Color("#36CF97").cornerRadius(20))
                }.padding(.horizontal, 22).padding(.bottom)
            }.background(Color.white.cornerRadius(10)).padding(.horizontal, 36)
            Spacer()
        }.background(Color.black.opacity(0.7).ignoresSafeArea())
    }
}

extension CleanSelectView {
    
    func dismiss() {
        store.dispatch(.dismiss)
    }
    
    func confirm() {
        store.dispatch(.dismiss)
        store.dispatch(.present(AnyView(CleanView().environmentObject(store)), .fullScreen))
    }
}

struct CleanSelectView_Previews: PreviewProvider {
    static var previews: some View {
        CleanSelectView()
    }
}
