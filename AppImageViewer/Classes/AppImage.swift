//
//  AppImage.swift
//  AppImageViewer
//
//  Created by Karthik on 1/27/18.
//

import UIKit
import Foundation

@objc public protocol AppImageProtocol: NSObjectProtocol {
    
    var index: Int { get set }
    var underlyingImage: UIImage! { get }
    var contentMode: UIViewContentMode { get set }
}

// MARK: - AppImage
open class AppImage: NSObject, AppImageProtocol {
    
    open var index: Int = 0
    open var underlyingImage: UIImage!
    open var contentMode: UIViewContentMode = .scaleAspectFill
    
    override init() {
        super.init()
    }
    
    convenience init(image: UIImage) {
        self.init()
        underlyingImage = image
    }


    // MARK: - Static Function
    public static func appImage(forImage image: UIImage) -> AppImage {
        return AppImage(image: image)
    }
}

