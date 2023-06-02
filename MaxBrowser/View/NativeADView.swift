//
//  NativeADView.swift
//  MaxBrowser
//
//  Created by yangjian on 2023/5/26.
//

import Foundation
import SwiftUI
import GoogleMobileAds

class NativeViewModel: NSObject {
    let ad: NativeADModel?
    let view: UINativeAdView
    init(ad: NativeADModel? = nil, view: UINativeAdView) {
        self.ad = ad
        self.view = view
        self.view.refreshUI(ad: ad?.nativeAd)
    }
    
    static var None:NativeViewModel {
        NativeViewModel(view: UINativeAdView())
    }
}


struct NativeView: UIViewRepresentable {
    let model: NativeViewModel
    func makeUIView(context: UIViewRepresentableContext<NativeView>) -> UIView {
        return model.view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<NativeView>) {
        if let uiView = uiView as? UINativeAdView {
            uiView.refreshUI(ad: model.ad?.nativeAd)
        }
    }
}

class UINativeAdView: GADNativeAdView {

    init(){
        super.init(frame: UIScreen.main.bounds)
        setupUI()
        refreshUI(ad: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 暫未圖
    lazy var placeholderView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var adView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "ad_tag"))
        return image
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11.0)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var installLabel: UIButton = {
        let label = UIButton()
        label.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.setTitleColor(UIColor.white, for: .normal)
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
        return label
    }()
}

extension UINativeAdView {
    func setupUI() {
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        addSubview(placeholderView)
        placeholderView.frame = self.bounds
        
        
        addSubview(iconImageView)
        iconImageView.frame = CGRectMake(14, 16, 44, 44)
        
        
        addSubview(titleLabel)
        let width = self.bounds.size.width - iconImageView.frame.maxX - 8 - 130
        titleLabel.frame = CGRectMake(iconImageView.frame.maxX + 8, 19, width, 15)

        
        addSubview(adView)
        adView.frame = CGRectMake(titleLabel.frame.maxX + 5, 19, 20, 12)
        
        addSubview(subTitleLabel)
        let w = self.bounds.size.width - iconImageView.frame.maxX - 8 - 110
        subTitleLabel.frame = CGRectMake(titleLabel.frame.minX, titleLabel.frame.maxY + 10, w, 12)

        
        addSubview(installLabel)
        let x = self.bounds.width - 15 - 72
        installLabel.frame = CGRectMake(x, 21, 72, 40)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    func refreshUI(ad: GADNativeAd? = nil) {
        self.nativeAd = ad
        placeholderView.image = UIImage(named: "ad_placeholder")
        let bgColor = UIColor(named: "#C9F8EA")
        self.backgroundColor = ad == nil ? .clear : bgColor
        self.adView.image = UIImage(named: "ad_tag")
        self.installLabel.setTitleColor(.white, for: .normal)
        self.installLabel.backgroundColor = UIColor(named: "#36CF97")
        self.subTitleLabel.textColor = UIColor(named: "#737373")
        self.titleLabel.textColor = UIColor(named: "#333333")
        
        self.iconView = self.iconImageView
        self.headlineView = self.titleLabel
        self.bodyView = self.subTitleLabel
        self.callToActionView = self.installLabel
        self.installLabel.setTitle(ad?.callToAction, for: .normal)
        self.iconImageView.image = ad?.icon?.image
        self.titleLabel.text = ad?.headline
        self.subTitleLabel.text = ad?.body
        
        self.hiddenSubviews(hidden: self.nativeAd == nil)
        
        if ad == nil {
            self.placeholderView.isHidden = false
        } else {
            self.placeholderView.isHidden = true
        }
    }
    
    func hiddenSubviews(hidden: Bool) {
        self.iconImageView.isHidden = hidden
        self.titleLabel.isHidden = hidden
        self.subTitleLabel.isHidden = hidden
        self.installLabel.isHidden = hidden
        self.adView.isHidden = hidden
    }
}
