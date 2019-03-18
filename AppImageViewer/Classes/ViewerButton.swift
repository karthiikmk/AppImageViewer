//
//  AppImageViewer
//
//  Created by Karthik on 1/27/18.
//

import Foundation

public struct ViewerButtonConfig {
    public static var buttonTopSpace: CGFloat = 30
    public static var padding: CGFloat = 10
    public static var buttonImageInset: CGFloat = 12
    public static var swapCloseAndMoreButton: Bool = false
    public static var closeButtonImage: UIImage?
    public static var moreButtonImage: UIImage?
    public static var shareImage: UIImage?
}

// helpers which often used
private let bundle = Bundle(for: AppImageViewer.self)

class ViewerButton: UIButton {
    
    internal var showFrame: CGRect!
    internal var hideFrame: CGRect!
    
    fileprivate var insets: UIEdgeInsets {
        return UIEdgeInsets(top: ViewerButtonConfig.buttonImageInset, left: ViewerButtonConfig.buttonImageInset, bottom: ViewerButtonConfig.buttonImageInset, right: ViewerButtonConfig.buttonImageInset)
    }
    
    fileprivate let size: CGSize = CGSize(width: 38, height: 38)
    fileprivate let buttonTopOffset: CGFloat = ViewerButtonConfig.buttonTopSpace
    fileprivate var margin: CGFloat = ViewerButtonConfig.padding

    func setup(_ image: UIImage) {
        
        backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.layer.cornerRadius = size.height/2
        self.clipsToBounds = true
        imageEdgeInsets = insets
        translatesAutoresizingMaskIntoConstraints = true
        autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin]        
        setImage(image, for: UIControl.State())
    }
  
    func setFrameSize(_ size: CGSize? = nil) {
        guard let size = size else { return }
        
        let newRect = CGRect(x: margin, y: buttonTopOffset, width: size.width, height: size.height)
        frame = newRect
        showFrame = newRect
        hideFrame = CGRect(x: margin, y: -20, width: size.width, height: size.height)
    }
    
    //will be overridden
    func updateFrame(_ frameSize: CGSize) {
        
    }
}

class ViewerImageButton: ViewerButton {
    
    fileprivate var leftSidePositionMargin: CGFloat {
        return super.margin
    }
    
    fileprivate var rightSidePositionMargin: CGFloat {
        return ViewerScale.screenWidth - super.margin - self.size.width
    }
    
    fileprivate var image: UIImage {
        return UIImage()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup(image)
        showFrame = CGRect(x: margin, y: buttonTopOffset, width: size.width, height: size.height)
        hideFrame = CGRect(x: margin, y: -20, width: size.width, height: size.height)
    }
}

class ViewerCloseButton: ViewerImageButton {
    
    override var image: UIImage {

        if let custom = ViewerButtonConfig.closeButtonImage {
            return custom
        }
        
        return AppImage.close.image
    }

    override var margin: CGFloat {
        get {
            return ViewerButtonConfig.swapCloseAndMoreButton ? rightSidePositionMargin : leftSidePositionMargin
        } set {
            super.margin = newValue
        }
    }
}

class ViewerDeleteButton: ViewerImageButton {
    
    override var image: UIImage {
        
        if let custom = ViewerButtonConfig.moreButtonImage {
            return custom
        }
        
        return UIImage()
    }
    
    override var margin: CGFloat {
        get {
            return ViewerButtonConfig.swapCloseAndMoreButton ? leftSidePositionMargin : rightSidePositionMargin
        } set {
            super.margin = newValue
        }
    }
    
    override func updateFrame(_ newScreenSize: CGSize) {
        showFrame = CGRect(x: newScreenSize.width - size.width, y: buttonTopOffset, width: size.width, height: size.height)
        hideFrame = CGRect(x: newScreenSize.width - size.width, y: -20, width: size.width, height: size.height)
    }
}
