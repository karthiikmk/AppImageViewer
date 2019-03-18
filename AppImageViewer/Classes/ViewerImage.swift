//
//  AppImage.swift
//  AppImageViewer
//
//  Created by Karthik on 1/27/18.
//

import UIKit
import Foundation

@objc public protocol ViewerImageProtocol: NSObjectProtocol {
    
    var index: Int { get set }
    var underlyingImage: UIImage! { get }
    var contentMode: UIView.ContentMode { get set }
    func loadUnderlyingImageAndNotify()
    func checkCache()
}

// MARK: - AppImage
open class ViewerImage: NSObject, ViewerImageProtocol {
    
    open var index: Int = 0
    open var underlyingImage: UIImage!
    open var contentMode: UIView.ContentMode = .scaleAspectFill
    open var shouldCachePhotoURLImage: Bool = false
    open var photoURL: String!
    
    override init() {
        super.init()
    }
    
    convenience init(image: UIImage) {
        self.init()
        underlyingImage = image
    }
    
    convenience init(url: String) {
        self.init()
        photoURL = url
    }

    
    open func checkCache() {
        //loadUnderlyingImageAndNotify()
        guard let photoURL = photoURL else { return }
        guard shouldCachePhotoURLImage else { return }

        if SKCache.sharedCache.imageCache is SKRequestResponseCacheable {
            let request = URLRequest(url: URL(string: photoURL)!)
            if let img = SKCache.sharedCache.imageForRequest(request) {
                underlyingImage = img
            }
        } else {
            if let img = SKCache.sharedCache.imageForKey(photoURL) {
                underlyingImage = img
            }
        }
    }
    
    open func loadUnderlyingImageAndNotify() {
        guard photoURL != nil, let URL = URL(string: photoURL) else { return }
        
        // Fetch Image
        let session = URLSession(configuration: SKPhotoBrowserOptions.sessionConfiguration)
        var task: URLSessionTask?
        task = session.dataTask(with: URL, completionHandler: { [weak self] (data, response, error) in
            guard let `self` = self else { return }
            defer { session.finishTasksAndInvalidate() }
            
            guard error == nil else {
                DispatchQueue.main.async {
                    self.loadUnderlyingImageComplete()
                }
                return
            }
            
            if let data = data, let response = response, let image = UIImage(data: data) {
                if self.shouldCachePhotoURLImage {
                    if SKCache.sharedCache.imageCache is SKRequestResponseCacheable {
                        SKCache.sharedCache.setImageData(data, response: response, request: task?.originalRequest)
                    } else {
                        SKCache.sharedCache.setImage(image, forKey: self.photoURL)
                    }
                }
                DispatchQueue.main.async {
                    self.underlyingImage = image
                    self.loadUnderlyingImageComplete()
                }
            }
            
        })
        task?.resume()
    }
    
    open func loadUnderlyingImageComplete() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: APPIMAGE_LOADING_DID_END_NOTIFICATION), object: self)
    }

    // MARK: - Static Function
    public static func appImage(forImage image: UIImage) -> ViewerImage {
        return ViewerImage(image: image)
    }
    
    public static func appImage(forUrl url: String) -> ViewerImage {
        return ViewerImage(url: url)
    }
}


