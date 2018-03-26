//
//  UIImage+Local.swift
//  Camma
//
//  Created by Steve Uffelman on 8/21/17.
//  Copyright © 2017 Steve Uffelman. All rights reserved.
//

import UIKit

extension UIImage {
 
    class func imageFor(_ guid: String?) -> UIImage? {
        guard let guid = guid else { return nil }
        do {
            let data = try Data(contentsOf: UIImage.filePath(for: guid))
            return UIImage(data: data)
        } catch let err {
            print(err)
            return nil
        }
    }
    
    class func filePath(for guid: String) -> URL {

        let documentsDir = FileManager.default.documentsDirectory()
        return documentsDir.appendingPathComponent("\(guid).jpg")
    }
}
