//
//  UIImage+Local.swift
//  Camma
//
//  Created by Steve Uffelman on 8/21/17.
//  Copyright © 2017 Steve Uffelman. All rights reserved.
//

import UIKit

extension UIImage {
 
    class func imageFor(_ path: URL) -> UIImage? {
        do {
            let data = try Data(contentsOf: path)
            return UIImage(data: data)
        } catch let err {
            print(err)
            return nil
        }
    }
    
    class func originalImagePath(for guid: String) -> URL {
        let documentsDir = FileManager.default.documentsDirectory()
        return documentsDir.appendingPathComponent("\(guid).jpg")
    }
    
    class func thumbnailPath(for guid: String) -> URL {
        let documentsDir = FileManager.default.documentsDirectory()
        return documentsDir.appendingPathComponent("\(guid)-thumbnail.jpg")
    }
    
//    func scaled(to size: CGSize) -> UIImage? {
//        UIGraphicsBeginImageContext( size )
//        draw(in: CGRect(x: 0,y: 0,width: size.width,height: size.height))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage?.withRenderingMode(.alwaysOriginal)
//    }
}
