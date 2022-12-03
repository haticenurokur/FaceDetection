//
//  Image+Ext.swift
//  FaceDetection
//
//  Created by Hatice Nur OKUR on 3.12.2022.
//

import UIKit


extension UIImage{
    func cropImage(toRect rect:CGRect) -> UIImage{
        let imageRef:CGImage = cgImage!.cropping(to: rect)!
        let croppedImage:UIImage = UIImage(cgImage:imageRef)
        return croppedImage
    }
}

extension CIImage{
    func convertToUiImage() -> UIImage {
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(self, from: extent)!
        let image = UIImage(cgImage: cgImage)
        return image
    }
}
