//
//  ViewController.swift
//  AppImageViewer
//
//  Created by karthikAdaptavant on 01/27/2018.
//  Copyright (c) 2018 karthikAdaptavant. All rights reserved.
//

import UIKit
import AppImageViewer

class ViewController: UIViewController {

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        switch tappedImage.tag {
            
        case 1, 2, 3:
            let appImage = AppImage.appImage(forImage: tappedImage.image!)
            let viewer = AppImageViewer(originImage: tappedImage.image!, photos: [appImage], animatedFromView: tappedImage)
            present(viewer, animated: true, completion: nil)
            
        default:
            break
        }
    }
}

