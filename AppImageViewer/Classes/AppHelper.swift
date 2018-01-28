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
        return UIImage(named: self.assetName, in: bulde, compatibleWith: nil) ?? UIImage()
    }
}
