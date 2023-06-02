//
//  Action.swift
//  MaxBrowser
//
//  Created by yangjian on 2023/5/23.
//

import Foundation
import Combine
import SwiftUI
import UIKit

enum AppAction {
    case luanching
    case launched
    
    case addBrowserObservable
    case hiddenKeyboard
    case alert(String)
    
    case load(String)
    case select(Browser)
    case delete(Browser)
    case newBrowser
    
    case present(AnyView, UIModalPresentationStyle)
    case dismiss
    
    case copy
    case clean
    
    case logEvent(FirebaseState.Event, [String: String]? = nil)
    case logProperty(FirebaseState.Property)
    
    case adRequestConfig
    case adUpdateConfig(GADConfig)
    case adUpdateLimit(GADLimit.Status)
    
    case adAppear(GADPosition)
    case adDisappear(GADPosition)
    
    case adClean(GADPosition)
    
    case adLoad(GADPosition, GADPosition.Position = .home)
    case adShow(GADPosition, GADPosition.Position = .home, ((NativeViewModel)->Void)? = nil)
    
    case adNativeImpressionDate(GADPosition.Position = .home)
    
    case adModel(NativeViewModel)
}

protocol AppCommand {
    func execute(in store: AppStore)
}

class SubscriptionToken {
    var cancelable: AnyCancellable?
    func unseal() { cancelable = nil }
}

extension AnyCancellable {
    func seal(in token: SubscriptionToken) {
        token.cancelable = self
    }
}

