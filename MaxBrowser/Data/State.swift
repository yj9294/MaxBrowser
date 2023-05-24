//
//  State.swift
//  MaxBrowser
//
//  Created by yangjian on 2023/5/23.
//

import Foundation

struct AppState {
    var tabbar = TabbarState()
    var home = HomeState()
    var firebase = FirebaseState()
}

struct TabbarState {
    var index: Index = .launch
    enum Index {
        case launch, home
    }
}

struct HomeState {
    var text: String = ""
    var isLoading: Bool = false
    var canGoBack: Bool = false
    var canGoForword: Bool = false
    var isNavigation: Bool = false
    var progress: Double = 0.0

    var browsers: [Browser] = [.navigation]
    var browser: Browser {
        browsers.filter {
            $0.isSelect
        }.first ?? .navigation
    }

    
    enum Index: String, CaseIterable {
        case facebook, google, youtube, twitter, instagram, amazon, tiktok, yahoo
        var title: String {
            return "\(self)".capitalized
        }
        var url: String {
            return "https://www.\(self).com"
        }
        var icon: String {
            return "\(self)"
        }
    }
}

struct FirebaseState {
    
    var item: FirebaseItem = .default
    
    enum Property: String {
        /// 設備
        case local = "ay_pe"
        
        var first: Bool {
            switch self {
            case .local:
                return true
            }
        }
    }
    
    enum Event: String {
        
        var first: Bool {
            switch self {
            case .open:
                return true
            default:
                return false
            }
        }
        
        case open = "lun_pe"
        case openCold = "er_pe"
        case openHot = "ew_pe"
        case homeShow = "eq_pe"
        case homeClickButton = "ws_pe"
        case homeClickSearch = "wa_pe"
        case homeClickClean = "bu_pe"
        
        case cleanAnimationCompletion = "xian_pe"
        case cleanCompletionAlertShow = "dd_pe"
        case tabShow = "dl_pe"
        case browserNew = "acv_pe"
        case shareClick = "xmo_pe"
        case copyClick = "qws_pe"
        case searchBegian = "zxc_pe"
        case searchSuccess = "bnm_pe"
    }
}
