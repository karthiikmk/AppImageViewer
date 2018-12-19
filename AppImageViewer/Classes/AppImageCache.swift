//
//  AppImageCache.swift
//  AppImageViewer
//
//  Created by Karthik on 12/13/18.
//

import Foundation

import UIKit.UIImage


public protocol SKCacheable {}

public protocol SKImageCacheable: SKCacheable {
    func imageForKey(_ key: String) -> UIImage?
    func setImage(_ image: UIImage, forKey key: String)
    func removeImageForKey(_ key: String)
    func removeAllImages()
}

public protocol SKRequestResponseCacheable: SKCacheable {
    func cachedResponseForRequest(_ request: URLRequest) -> CachedURLResponse?
    func storeCachedResponse(_ cachedResponse: CachedURLResponse, forRequest request: URLRequest)
}

open class SKCache {
    public static let sharedCache = SKCache()
    open var imageCache: SKCacheable
    
    init() {
        self.imageCache = SKDefaultImageCache()
    }
    
    open func imageForKey(_ key: String) -> UIImage? {
        guard let cache = imageCache as? SKImageCacheable else {
            return nil
        }
        
        return cache.imageForKey(key)
    }
    
    open func setImage(_ image: UIImage, forKey key: String) {
        guard let cache = imageCache as? SKImageCacheable else {
            return
        }
        
        cache.setImage(image, forKey: key)
    }
    
    open func removeImageForKey(_ key: String) {
        guard let cache = imageCache as? SKImageCacheable else {
            return
        }
        
        cache.removeImageForKey(key)
    }
    
    open func removeAllImages() {
        guard let cache = imageCache as? SKImageCacheable else {
            return
        }
        
        cache.removeAllImages()
    }
    
    open func imageForRequest(_ request: URLRequest) -> UIImage? {
        guard let cache = imageCache as? SKRequestResponseCacheable else { return nil }
        
        if let response = cache.cachedResponseForRequest(request) {
            return UIImage(data: response.data)
        }
        return nil
    }
    
    open func setImageData(_ data: Data, response: URLResponse, request: URLRequest?) {
        guard let cache = imageCache as? SKRequestResponseCacheable, let request = request else {
            return
        }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        cache.storeCachedResponse(cachedResponse, forRequest: request)
    }
}

class SKDefaultImageCache: SKImageCacheable {
    var cache: NSCache<AnyObject, AnyObject>
    
    init() {
        cache = NSCache()
    }
    
    func imageForKey(_ key: String) -> UIImage? {
        return cache.object(forKey: key as AnyObject) as? UIImage
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as AnyObject)
    }
    
    func removeImageForKey(_ key: String) {
        cache.removeObject(forKey: key as AnyObject)
    }
    
    func removeAllImages() {
        cache.removeAllObjects()
    }
}

public struct SKPhotoBrowserOptions {
    public static var displayStatusbar: Bool = false
    public static var displayCloseButton: Bool = true
    public static var displayDeleteButton: Bool = false
    
    public static var displayAction: Bool = true
    public static var shareExtraCaption: String?
    public static var actionButtonTitles: [String]?
    
    public static var displayCounterLabel: Bool = true
    public static var displayBackAndForwardButton: Bool = true
    
    public static var displayHorizontalScrollIndicator: Bool = true
    public static var displayVerticalScrollIndicator: Bool = true
    public static var displayPagingHorizontalScrollIndicator: Bool = true
    
    public static var bounceAnimation: Bool = false
    public static var enableZoomBlackArea: Bool = true
    public static var enableSingleTapDismiss: Bool = false
    
    public static var backgroundColor: UIColor = .black
    public static var indicatorColor: UIColor = .white
    public static var indicatorStyle: UIActivityIndicatorView.Style = .whiteLarge
    
    /// By default close button is on left side and delete button is on right.
    ///
    /// Set this property to **true** for swap they.
    ///
    /// Default: false
    public static var swapCloseAndDeleteButtons: Bool = false
    public static var disableVerticalSwipe: Bool = false
    
    /// if this value is true, the long photo width will match the screen,
    /// and the minScale is 1.0, the maxScale is 2.5
    /// Default: false
    public static var longPhotoWidthMatchScreen: Bool = false
    
    /// Provide custom session configuration (eg. for headers, etc.)
    public static var sessionConfiguration: URLSessionConfiguration = .default
}


struct SKMesurement {
    static let isPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
    static let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    static var statusBarH: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    static var screenHeight: CGFloat {
        return UIApplication.shared.preferredApplicationWindow?.bounds.height ?? UIScreen.main.bounds.height
    }
    static var screenWidth: CGFloat {
        return UIApplication.shared.preferredApplicationWindow?.bounds.width ?? UIScreen.main.bounds.width
    }
    static var screenScale: CGFloat {
        return UIScreen.main.scale
    }
    static var screenRatio: CGFloat {
        return screenWidth / screenHeight
    }
    static var isPhoneX: Bool {
        if isPhone && UIScreen.main.nativeBounds.height == 2436 {
            return true
        }
        return false
    }
}
