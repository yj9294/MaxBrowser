//
//  Store.swift
//  MaxBrowser
//
//  Created by yangjian on 2023/5/23.
//

import Foundation
import Combine

class AppStore: ObservableObject {
    @Published var state: AppState = AppState()
    var bags = [AnyCancellable]()
    init() {
        dispatch(.logProperty(.local))
        dispatch(.logEvent(.open))
        dispatch(.logEvent(.openCold))
        dispatch(.adRequestConfig)
    }
    func dispatch(_ action: AppAction) {
        debugPrint("[ACTION]: \(action)")
        let result = AppStore.reduce(state: state, action: action)
        state = result.0
        if let command = result.1 {
            command.execute(in: self)
        }
    }
}

extension AppStore{
    private static func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand? = nil
        switch action {
        case .luanching:
            appState.tabbar.progress = 0
            appState.tabbar.index = .launch
        case .launched:
            appState.tabbar.index = .home
            
        case .addBrowserObservable:
            appCommand = BrowserCommand()
        case .hiddenKeyboard:
            appCommand = KeyboardCommand()
        case .alert(let message):
            appCommand = AlertCommand(message)
        case .load(let url):
            appState.home.text = url
            appState.home.progress = 0.0
            appState.home.browser.load(url)
            
        case .select(let browser):
            appState.home.browsers.forEach {
                $0.isSelect = false
            }
            browser.isSelect = true
            
        case .delete(let browser):
            if browser.isSelect {
                appState.home.browsers = appState.home.browsers.filter({
                    !$0.isSelect
                })
                appState.home.browsers.first?.isSelect = true
            } else {
                appState.home.browsers = appState.home.browsers.filter({
                    $0.webView != browser.webView
                })
            }
        case .newBrowser:
            appState.home.browsers.forEach {
                $0.isSelect = false
            }
            appState.home.browsers.insert(.navigation, at: 0)
        case .present(let view, let style):
            appCommand = PresentCommand(content: view, presentStyle: style)
        case .dismiss:
            appCommand = DismissCommand()
            
        case .copy:
            appCommand = CopyCommand()
        case .clean:
            appState.home.isLoading = false
            appState.home.text = ""
            appState.home.browsers = [.navigation]
            
        case .logEvent(let event, let params):
            appCommand = FirebaseEventCommand(event: event, params: params)
        case .logProperty(let property):
            appCommand = FirebasePropertyCommand(property: property)
            
        case .adRequestConfig:
            appCommand = GADRemoteConfigCommand()
        case .adUpdateConfig(let config):
            appState.ad.config = config
        case .adUpdateLimit(let state):
            appCommand = GADUpdateLimitCommand(state)
        case .adAppear(let position):
            appCommand = GADAppearCommand(position)
        case .adDisappear(let position):
            appCommand = GADDisappearCommand(position)
        case .adClean(let position):
            appCommand = GADCleanCommand(position)
        
        case .adLoad(let position, let p):
            appCommand = GADLoadCommand(position, p)
        case .adShow(let position, let p, let completion):
            appCommand = GADShowCommand(position, p, completion)
            
        case .adNativeImpressionDate(let p):
            appState.ad.impressionDate[p] = Date()
        case .adModel(let model):
            appState.tabbar.adModel = model

        }
        return (appState, appCommand)
    }
}
