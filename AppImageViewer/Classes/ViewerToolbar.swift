//
//  SKToolbar.swift
//  SKPhotoBrowser
//
//  Created by keishi_suzuki on 2017/12/20.
//  Copyright © 2017年 suzuki_keishi. All rights reserved.
//

import Foundation

// helpers which often used
private let bundle = Bundle(for: AppImageViewer.self)

class ViewerToolbar: UIView {
    
    var toolActionButton: UIBarButtonItem!
    
    fileprivate weak var browser: AppImageViewer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, browser: AppImageViewer) {
        self.init(frame: frame)
        self.browser = browser
        
        setupApperance()
        setupToolbar()
    }

    func setupApperance() {
        backgroundColor = .clear
        clipsToBounds = true
    }
    
    func setupToolbar() {
        
         let image = UIImage(named: "SKPhotoBrowser.bundle/images/btn_common_share_wh",
            in: bundle, compatibleWith: nil) ?? UIImage()
        
        guard let brower  = self.browser else {
            return
        }
        
        let x = brower.shareButtonSide == .left ? self.frame.origin.x + ViewerButtonConfig.padding : self.frame.width - 55
        let btn = UIButton(frame: CGRect(x: x, y: 0, width: 38, height: 38))
        btn.setImage(image, for: .normal)
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        btn.layer.cornerRadius = btn.frame.height/2
        btn.clipsToBounds = true
        btn.addTarget(browser, action: #selector(browser?.actionButtonPressed(_:)), for: .touchUpInside)
        self.addSubview(btn)
    }
}

