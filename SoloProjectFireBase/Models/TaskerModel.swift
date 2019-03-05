//
//  TaskerModel.swift
//  SoloProjectFireBase
//
//  Created by Olimpia on 2/25/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import Foundation

struct Tasker {
    
    let taskTitle: String
    let taskType: String
    let dbreferenceDocumentIdL: String
    
    init(taskTitle: String, taskType: String, dbreferenceDocumentIdL: String) {
        self.taskTitle = taskTitle
        self.taskType = taskType
        self.dbreferenceDocumentIdL = dbreferenceDocumentIdL
    }
   
    init(dict: [String: Any]) {
        self.taskTitle = dict["taskName"] as? String ?? "no task name"
        self.taskType = dict["taskType"] as? String ?? "no task type"
        self.dbreferenceDocumentIdL = dict["dbReference"] as? String ?? "no dbReference"
    }

}
