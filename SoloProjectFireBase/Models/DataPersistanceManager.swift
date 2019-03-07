//
//  DataPersistanceManager.swift
//  SoloProjectFireBase
//
//  Created by Olimpia on 3/6/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import Foundation

final class DataPersistenceManager {
    
    
    static func documentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func filepathToDocumentsDirectory(filename: String) -> URL {
        return documentsDirectory().appendingPathComponent(filename)
    }
}
