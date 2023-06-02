//
//  BrowserCommand.swift
//  MaxBrowser
//
//  Created by yangjian on 2023/5/23.
//

import Foundation
import SwiftUI
import Combine
import UIKit
import MobileCoreServices

struct BrowserCommand: AppCommand {
    func execute(in store: AppStore) {
        store.state.home.text = ""
        
        let webView = store.state.home.browser.webView

        let goback = webView.publisher(for: \.canGoBack).sink { canGoBack in
            store.state.home.canGoBack = canGoBack
        }
        
        let goForword = webView.publisher(for: \.canGoForward).sink { canGoForword in
            store.state.home.canGoForword = canGoForword
        }
        
        let isLoading = webView.publisher(for: \.isLoading).sink { isLoading in
            debugPrint("isloading \(isLoading)")
            store.state.home.isLoading = isLoading
        }
        
        var start = Date()
        let progress = webView.publisher(for: \.estimatedProgress).sink { progress in
            if progress == 0.1 {
                start = Date()
                store.dispatch(.logEvent(.searchBegian))
            }
            if progress == 1.0 {
                let time = Date().timeIntervalSince1970 - start.timeIntervalSince1970
                store.dispatch(.logEvent(.searchSuccess, ["bro": "\(ceil(time))"]))
            }
            store.state.home.progress = progress
        }
        
        let isNavigation = webView.publisher(for: \.url).map{$0 == nil}.sink { isNavigation in
            store.state.home.isNavigation = isNavigation
        }
        
        let url = webView.publisher(for: \.url).compactMap{$0}.sink { url in
            store.state.home.text = url.absoluteString
        }
        
        store.bags = [goback, goForword, progress, isLoading, isNavigation, url]
    }
}

struct KeyboardCommand: AppCommand {
    func execute(in store: AppStore) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct AlertCommand: AppCommand {
    let message: String
    init(_ message: String) {
        self.message = message
    }
    
    func execute(in store: AppStore) {
        let windowScenedelegate: UIScene? = UIApplication.shared.connectedScenes.filter({
            $0.delegate is UIWindowSceneDelegate
        }).first
        if let screnDelegate = windowScenedelegate?.delegate as? UIWindowSceneDelegate {
            let vc = screnDelegate.window!?.rootViewController
            let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            vc?.present(alert, animated: true)
            Task {
                if !Task.isCancelled {
                    try await Task.sleep(nanoseconds: 2_000_000_000)
                    await alert.dismiss(animated: true)
                }
            }
        }
    }
}

struct PresentCommand<T>: AppCommand where T : View {
    let content: T
    let presentStyle: UIModalPresentationStyle
    func execute(in store: AppStore) {
        let vc = UIHostingController(rootView: content)
        let windowScenedelegate: UIScene? = UIApplication.shared.connectedScenes.filter({
            $0.delegate is UIWindowSceneDelegate
        }).first
        if let screnDelegate = windowScenedelegate?.delegate as? UIWindowSceneDelegate {
            let rootVC = screnDelegate.window!?.rootViewController
            vc.modalPresentationStyle = presentStyle
            if presentStyle == .overCurrentContext {
                vc.view.backgroundColor = .clear
            }
            rootVC?.present(vc, animated: true)
        }
    }
}

struct DismissCommand: AppCommand {
    func execute(in store: AppStore) {
        let windowScenedelegate: UIScene? = UIApplication.shared.connectedScenes.filter({
            $0.delegate is UIWindowSceneDelegate
        }).first
        if let screnDelegate = windowScenedelegate?.delegate as? UIWindowSceneDelegate {
            let vc = screnDelegate.window!?.rootViewController
            if let presentVC = vc?.presentedViewController {
                if let pre = presentVC.presentedViewController {
                    pre.dismiss(animated: true) {
                        presentVC.dismiss(animated: true)
                    }
                } else {
                    presentVC.dismiss(animated: true)
                }
            }
        }
    }
}

struct CopyCommand: AppCommand {
    func execute(in store: AppStore) {
        if store.state.home.browser.isNavigation {
            UIPasteboard.general.setValue("", forPasteboardType: kUTTypePlainText as String)
        } else {
            UIPasteboard.general.setValue(store.state.home.text, forPasteboardType: kUTTypePlainText as String)
        }
        store.dispatch(.alert("Copy Successful."))
    }
}

struct FirebaseEventCommand: AppCommand {
    let event: FirebaseState.Event
    let params: [String: String]?
    func execute(in store: AppStore) {
        store.state.firebase.item.log(event: event, params: params)
    }
}

struct FirebasePropertyCommand: AppCommand {
    let property: FirebaseState.Property
    func execute(in store: AppStore) {
        store.state.firebase.item.log(property: property)
    }
}
