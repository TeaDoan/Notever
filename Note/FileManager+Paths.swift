//
//  FileManager+Paths.swift
//  Scrappr
//
//  Created by Steve Uffelman on 7/1/17.
//  Copyright © 2017 Steve Uffelman. All rights reserved.
//

import Foundation


extension FileManager {
    
    func documentsDirectory() -> URL {
        let paths = urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
