//
//  AppHelper.swift
//  AppImageViewer
//
//  Created by Karthik on 1/28/18.
//

import Foundation

private var bulde = Bundle(for: AppImageViewer.self)

internal enum AppImage {
    
    case close
    case share
    
    var assetName: String {
        switch self {
        case .close:
            return "close_white"
        case .share:
            return "share_white"
        }
    }
    
    var image: UIImage {
        return AppImageViewerUtils.getImageFromBundle(name: self.assetName)
    }
}

class AppImageViewerUtils {
    
    static func getBundle() -> Bundle? {
        
        let podBundle = Bundle(for: AppImageViewer.self)
        
        guard let bundleUrl = podBundle.url(forResource: "AppImageViewer", withExtension: "bundle") else {
            return nil
        }
        
        guard let bundle = Bundle(url: bundleUrl) else {
            return nil
        }
        
        return bundle
    }
    
    static func getImageFromBundle(name: String = "AppImageViewer") -> UIImage {
        
        guard let podBundle = self.getBundle(), let image = UIImage(named: name, in: podBundle, compatibleWith: nil) else {
            return UIImage()
        }
        
        return image
    }
}
