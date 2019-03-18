//
//  AppImageViewer
//
//  Created by Karthik on 1/27/18.
//

import UIKit

@objc public protocol ViewAnimatorDelegate {
    func willPresent(_ browser: AppImageViewer)
    func willDismiss(_ browser: AppImageViewer)
}

class ViewAnimator: NSObject, ViewAnimatorDelegate {
    
    fileprivate let window = UIApplication.shared.preferredApplicationWindow
    fileprivate var resizableImageView: UIImageView?
    fileprivate var finalImageViewFrame: CGRect = .zero
    
    internal lazy var backgroundView: UIView = {
        guard let window = UIApplication.shared.preferredApplicationWindow else { fatalError() }
        
        let backgroundView = UIView(frame: window.frame)
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.0
        return backgroundView
    }()
    
    internal var bounceAnimation: Bool = true
    
    internal var senderOriginImage: UIImage!
    internal var senderViewOriginalFrame: CGRect = .zero
    internal var senderViewForAnimation: UIView?
    
    fileprivate var animationDuration: TimeInterval {
        return bounceAnimation ? 0.5 : 0.35
    }
    
    fileprivate var animationDamping: CGFloat {
        return bounceAnimation ? 0.8 : 1.0
    }
    
    override init() {
        super.init()
        window?.addSubview(backgroundView)
    }
    
    deinit {
        backgroundView.removeFromSuperview()
    }
    
    func willPresent(_ browser: AppImageViewer) {
        
        guard let sender = browser.delegate?.viewForPhoto?(browser, index: browser.currentPageIndex) ?? senderViewForAnimation else {
            presentAnimation(browser)
            return
        }

        let photo = browser.photoAtIndex(browser.currentPageIndex)
        let imageFromView = (senderOriginImage ?? browser.getImageFromView(sender)).rotateImageByOrientation()
        let imageRatio = imageFromView.size.width / imageFromView.size.height
        
        senderOriginImage = nil
        senderViewOriginalFrame = calcOriginFrame(sender)
        finalImageViewFrame = calcFinalFrame(imageRatio)
        resizableImageView = UIImageView(image: imageFromView)
        
        if let resizableImageView = resizableImageView {
            resizableImageView.frame = senderViewOriginalFrame
            resizableImageView.clipsToBounds = true
            resizableImageView.contentMode = photo.contentMode
            if sender.layer.cornerRadius != 0 {
                let duration = (animationDuration * Double(animationDamping))
                resizableImageView.layer.masksToBounds = true
                resizableImageView.addCornerRadiusAnimation(sender.layer.cornerRadius, to: 0, duration: duration)
            }
            window?.addSubview(resizableImageView)
        }

        presentAnimation(browser)
    }
    
    func willDismiss(_ browser: AppImageViewer) {
        
        guard let sender = browser.delegate?.viewForPhoto?(browser, index: browser.currentPageIndex),
            let image = browser.photoAtIndex(browser.currentPageIndex).underlyingImage,
            let scrollView = browser.pageDisplayedAtIndex(browser.currentPageIndex) else {
                
            senderViewForAnimation?.isHidden = false
            browser.dismissPhotoBrowser(animated: false)
            return
        }

        senderViewForAnimation = sender
        browser.view.isHidden = true
        backgroundView.isHidden = false
        backgroundView.alpha = 1.0
        backgroundView.backgroundColor = .clear
        senderViewOriginalFrame = calcOriginFrame(sender)
        
        if let resizableImageView = resizableImageView {
            let photo = browser.photoAtIndex(browser.currentPageIndex)
            let contentOffset = scrollView.contentOffset
            let scrollFrame = scrollView.imageView.frame
            let offsetY = scrollView.center.y - (scrollView.bounds.height/2)
            let frame = CGRect(
                x: scrollFrame.origin.x - contentOffset.x,
                y: scrollFrame.origin.y + contentOffset.y + offsetY,
                width: scrollFrame.width,
                height: scrollFrame.height)
            
            resizableImageView.image = image.rotateImageByOrientation()
            resizableImageView.frame = frame
            resizableImageView.alpha = 1.0
            resizableImageView.clipsToBounds = true
            resizableImageView.contentMode = photo.contentMode
            if let view = senderViewForAnimation, view.layer.cornerRadius != 0 {
                let duration = (animationDuration * Double(animationDamping))
                resizableImageView.layer.masksToBounds = true
                resizableImageView.addCornerRadiusAnimation(0, to: view.layer.cornerRadius, duration: duration)
            }
        }
        dismissAnimation(browser)
    }
}

private extension ViewAnimator {
    func calcOriginFrame(_ sender: UIView) -> CGRect {
        if let senderViewOriginalFrameTemp = sender.superview?.convert(sender.frame, to: nil) {
            return senderViewOriginalFrameTemp
        } else if let senderViewOriginalFrameTemp = sender.layer.superlayer?.convert(sender.frame, to: nil) {
            return senderViewOriginalFrameTemp
        } else {
            return .zero
        }
    }
    
    func calcFinalFrame(_ imageRatio: CGFloat) -> CGRect {
        if ViewerScale.screenRatio < imageRatio {
            let width = ViewerScale.screenWidth
            let height = width / imageRatio
            let yOffset = (ViewerScale.screenHeight - height) / 2
            return CGRect(x: 0, y: yOffset, width: width, height: height)
        } else {
            let height = ViewerScale.screenHeight
            let width = height * imageRatio
            let xOffset = (ViewerScale.screenWidth - width) / 2
            return CGRect(x: xOffset, y: 0, width: width, height: height)
        }
    }
}

private extension ViewAnimator {
    func presentAnimation(_ browser: AppImageViewer, completion: (() -> Void)? = nil) {
        let finalFrame = self.finalImageViewFrame
        browser.view.isHidden = true
        browser.view.alpha = 0.0

        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            usingSpringWithDamping: animationDamping,
            initialSpringVelocity: 0,
            options: UIView.AnimationOptions(),
            animations: {
                browser.showButtons()
                self.backgroundView.alpha = 1.0
                self.resizableImageView?.frame = finalFrame
            },
            completion: { (_) -> Void in
                browser.view.alpha = 1.0
                browser.view.isHidden = false
                self.backgroundView.isHidden = true
                self.resizableImageView?.alpha = 0.0
            })
    }
    
    func dismissAnimation(_ browser: AppImageViewer, completion: (() -> Void)? = nil) {
        let finalFrame = self.senderViewOriginalFrame

        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            usingSpringWithDamping: animationDamping,
            initialSpringVelocity: 0,
            options: UIView.AnimationOptions(),
            animations: {
                self.backgroundView.alpha = 0.0
                self.resizableImageView?.layer.frame = finalFrame
            },
            completion: { (_) -> Void in
                browser.dismissPhotoBrowser(animated: true) {
                    self.resizableImageView?.removeFromSuperview()
                    self.backgroundView.removeFromSuperview()
                }
            })
    }
}

