//
//  IdentityImageViewController.swift
//  FaceDetection
//
//  Created by Hatice Nur OKUR on 2.12.2022.
//

import UIKit

class IdentityImageVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let image = image {
            imageView.image = image
            imageView.transform = imageView.transform.rotated(by: .pi / 2)
        }
    }
    
}
