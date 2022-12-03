//
//  CropIdentityPhotoViewModel.swift
//  FaceDetection
//
//  Created by Hatice Nur OKUR on 3.12.2022.
//

import Foundation
import AVKit

class CropIdentityPhotoViewModel {
    var processedFrame:UIImage?
    var processedCIImage:CIImage?
    private var faceRects = [CGRect]()
    var faceboundsFound = false
    
    var captureDeviceResolution: CGSize = CGSize()
    
    private func detectIdentityImage() -> UIImage? {
        
        guard let personciImage = processedCIImage else {
            return nil
        }
        
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        guard let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy) else {return nil}
        let faces = faceDetector.features(in: personciImage)
        
        let ciImageSize = personciImage.extent.size
        var transform = CGAffineTransformMakeScale(1, -1)
        transform = CGAffineTransformTranslate(transform, 0, -ciImageSize.height)
        
        for face in faces as! [CIFaceFeature] {
            self.faceRects.append(face.bounds)
            
            if let newRect = findAverage() {
                var faceViewBounds = CGRectApplyAffineTransform(newRect, transform)
                
                let viewSize = captureDeviceResolution
                let scale = min(viewSize.width / ciImageSize.width,
                                viewSize.height / ciImageSize.height)
                let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
                let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
                
                faceViewBounds = CGRectApplyAffineTransform(faceViewBounds, CGAffineTransformMakeScale(scale, scale))
                faceViewBounds.origin.x += offsetX
                faceViewBounds.origin.y += offsetY
                
                if let croppedImage = self.processedFrame?.cropImage(toRect: faceViewBounds) {
                    self.faceboundsFound = true
                    return croppedImage
                    
                    
                }
            }
        }
        
        return nil
    }
    
    func getIdentityImage(completion: @escaping (UIImage?) -> Void) {
        if let identityImage = detectIdentityImage() {
            completion(identityImage)
        } else {
            completion(nil)
        }
    }
    
    func findAverage() -> CGRect? {
        let count = self.faceRects.count
        if count < 3 {
            return nil
        }
        
        let third = self.faceRects[count-3]
        let second = self.faceRects[count-2]
        let first = self.faceRects[count-1]
        
        let x = (first.origin.x + second.origin.x + third.origin.x) / 3.0
        let y = (first.origin.y + second.origin.y + third.origin.y) / 3.0
        let width = (first.width + second.width + third.width) / 3.0
        let height = (first.height + second.height + third.height) / 3.0
        
        let newRect = CGRect(x: x, y: y, width: width, height: height)
        return newRect
    }
    
}
