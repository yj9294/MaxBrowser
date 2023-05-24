//
//  PrivacyView.swift
//  MaxBrowser
//
//  Created by yangjian on 2023/5/24.
//

import SwiftUI

struct PrivacyView: View {
    
    @EnvironmentObject var store: AppStore
    
    let index: Index
    
    var body: some View {
        VStack{
            ZStack {
                HStack{
                    Button(action: back) {
                        Image("setting_back")
                    }
                    Spacer()
                }.padding(.horizontal, 24)
                Text(index.title).foregroundColor(Color("#333333"))
            }.frame(height: 56)
            ScrollView{
                Text(index.body)
            }.padding(.horizontal, 20)
        }.background(Image("launch_background").resizable().scaledToFill())
    }
}

extension PrivacyView {
    
    enum Index{
        case privacy, terms
        var title: String {
            switch self {
            case .privacy:
                return "Privacy Policy"
            case .terms:
                return "Terms of Users"
            }
        }
        
        var body: String {
            switch self {
            case .privacy:
                return """
Privacy Policy
Please read our Privacy Policy in detail. This Privacy Policy is to let you know what information we collect about you, how we use it, and how we share it.
What information will we collect
IP address, platform, application identifier, device identifier independent of application version, terminal manufacturer, terminal device operating system version, language location, time zone and network status, CPU and screen resolution, memory usage, storage usage, advertising loading strategy, advertising platform and advertising delivery ID. Operating system version.
How we will use the information
Based on your needs and feedback, improve our application or develop and provide new features and services, update and develop services.
Detect and fix bugs in order to provide you with better service.
Respond to your opinions and questions, and provide support for you.
We may share your personal information with trusted partners or service providers.
We may provide your personal information to relevant law enforcement agencies or government departments to enforce or assist in enforcing certain laws or administrative procedures.
How we share information
We may provide your personal information to relevant law enforcement agencies or government departments to enforce or assist in enforcing certain laws or administrative procedures.
We may share your personal information with trusted partners or service providers.
google play services：https://policies.google.com/privacy
AdMob：https://support.google.com/admob
Google Analytics for Firebase：https://firebase.google.com/policies/analytics
Firebase Crashlytics：https://firebase.google.com/support/privacy/
Facebook：https://www.facebook.com/about/privacy/update/printable
Update
We will update these terms and conditions from time to time, and your continued use of our services will indicate that you accept our updated terms.
Contact us
If you have any questions about our privacy policy, please contact us.
UHs11111577@outlook.com
"""
            case .terms:
                return """
Please read these Terms of Use in detail
Use of the application
You accept that you may not use this application for illegal purposes
You accept that we may discontinue the service of the application at any time without prior notice to you
You accept using our application in accordance with the terms of this page, if you reject the terms of this page, please do not use our services
Update
We may update our Terms of Use from time to time. We recommend that you review these Terms of Use periodically for changes.
Contact us
If you have any questions about these Terms of Use, please contact us
UHs11111577@outlook.com
"""
            }
        }
    }
}

extension PrivacyView {
    
    func back() {
        store.dispatch(.dismiss)
    }
}

struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyView(index: .privacy)
    }
}
