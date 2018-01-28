//
//  AppImageViewer
//
//  Created by Karthik on 1/27/18.
//

import UIKit

class ViewerActionView: UIView {
    
    internal weak var browser: AppImageViewer?
    internal var closeButton: ViewerCloseButton!
    internal var deleteButton: ViewerDeleteButton!
    
    // Action
    fileprivate var cancelTitle = "Cancel"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, browser: AppImageViewer) {
        self.init(frame: frame)
        self.browser = browser

        configureCloseButton()
        configureDeleteButton()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let view = super.hitTest(point, with: event) {
            if closeButton.frame.contains(point) || deleteButton.frame.contains(point) {
                return view
            }
            return nil
        }
        return nil
    }
    
    func updateFrame(frame: CGRect) {
        self.frame = frame
        setNeedsDisplay()
    }

    func updateCloseButton(image: UIImage, size: CGSize? = nil) {
        configureCloseButton(image: image, size: size)
    }
    
    func updateDeleteButton(image: UIImage, size: CGSize? = nil) {
        configureDeleteButton(image: image, size: size)
    }
    
    func animate(hidden: Bool) {
        
        let closeFrame: CGRect = hidden ? closeButton.hideFrame : closeButton.showFrame
        let deleteFrame: CGRect = hidden ? deleteButton.hideFrame : deleteButton.showFrame
        
        UIView.animate(withDuration: 0.35) {
            
            let alpha: CGFloat = hidden ? 0.0 : 1.0
            
            self.closeButton.alpha = alpha
            self.closeButton.frame = closeFrame
            
            if let viewer = self.browser, viewer.displayDeleteButton {
                self.deleteButton.alpha = alpha
                self.deleteButton.frame = deleteFrame
            }
        }
    }
    
    @objc func closeButtonPressed(_ sender: UIButton) {
        browser?.determineAndClose()
    }
    
    @objc func deleteButtonPressed(_ sender: UIButton) {
        browser?.didMoreButtonTap()
    }
}

extension ViewerActionView {
    
    func configureCloseButton(image: UIImage? = nil, size: CGSize? = nil) {
        
        if closeButton == nil {
            closeButton = ViewerCloseButton(frame: .zero)
            closeButton.addTarget(self, action: #selector(closeButtonPressed(_:)), for: .touchUpInside)
            closeButton.isHidden = false
            addSubview(closeButton)
        }

        guard let size = size else {
            return
        }
        
        closeButton.setFrameSize(size)
        
        guard let image = image else {
            return
        }
        
        closeButton.setImage(image, for: UIControlState())
    }
    
    func configureDeleteButton(image: UIImage? = nil, size: CGSize? = nil) {
        if deleteButton == nil {
            deleteButton = ViewerDeleteButton(frame: .zero)
            deleteButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
            if let viewer = browser, viewer.displayDeleteButton {
                deleteButton.isHidden = false
            } else {
                deleteButton.isHidden = true
            }
            
            addSubview(deleteButton)
        }

        guard let size = size else { return }
        deleteButton.setFrameSize(size)
        
        guard let image = image else { return }
        deleteButton.setImage(image, for: UIControlState())
    }
}
