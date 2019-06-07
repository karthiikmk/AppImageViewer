//
//  ViewController.swift
//  AppImageViewer
//
//  Created by karthikAdaptavant on 01/27/2018.
//  Copyright (c) 2018 karthikAdaptavant. All rights reserved.
//

import UIKit
import AppImageViewer

class ViewController: UIViewController, AppImageViewerDelegate {

    @IBOutlet weak var imageview1: UIImageView!{
        didSet {
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imageview1.isUserInteractionEnabled = true
            imageview1.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    @IBOutlet weak var imageview2: UIImageView! {
        didSet {
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imageview2.isUserInteractionEnabled = true
            imageview2.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    @IBOutlet weak var imageview3: UIImageView! {
        didSet {
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imageview3.isUserInteractionEnabled = true
            imageview3.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        switch tappedImage.tag {
            
        case 1, 2, 3:
            
            let appImage = ViewerImage.appImage(forUrl: "https://avatars3.githubusercontent.com/u/39947022?s=460&v=4")
            appImage.shouldCachePhotoURLImage = true
            let appImage1 = ViewerImage.appImage(forUrl: "https://avatars3.githubusercontent.com/u/11072850?s=460&v=4")
            let viewer = AppImageViewer(originImage: nil, photos: [appImage, appImage1], animatedFromView: tappedImage)            
            viewer.delegate = self
            present(viewer, animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    func didTapShareButton(atIndex index: Int, _ browser: AppImageViewer) {
        print("share button tapped")
    }
    
    func didTapMoreButton(atIndex index: Int, _ browser: AppImageViewer) {
        
    }
}

