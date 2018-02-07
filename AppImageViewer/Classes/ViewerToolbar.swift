//
//  AppImageViewer
//
//  Created by Karthik on 1/27/18.
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
        
        guard let brower  = self.browser else {
            return
        }
        
        let x = brower.shareButtonSide == .left ? self.frame.origin.x + ViewerButtonConfig.padding : self.frame.width - 55
        let btn = UIButton(frame: CGRect(x: x, y: 0, width: 38, height: 38))
        
        if let shareImage = ViewerButtonConfig.shareImage {
            btn.setImage(shareImage, for: .normal)
            btn.setImage(shareImage, for: .selected)
        } else {
            btn.setImage(AppImage.share.image, for: .normal)
            btn.setImage(AppImage.share.image, for: .selected)
        }
        
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        btn.layer.cornerRadius = btn.frame.height/2
        btn.clipsToBounds = true
        btn.addTarget(browser, action: #selector(browser?.actionButtonPressed(_:)), for: .touchUpInside)
        self.addSubview(btn)
    }
}

