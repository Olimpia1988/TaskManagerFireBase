//
//  TaskerModel.swift
//  SoloProjectFireBase
//
//  Created by Olimpia on 2/25/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import Foundation

struct Tasker: Codable, Equatable {
    
    let taskTitle: String
    let taskType: String
    let createdAt: String
    let dbreferenceDocumentIdL: String
    
    
    init(taskTitle: String, taskType: String, createdAt: String, dbreferenceDocumentIdL: String) {
        self.taskTitle = taskTitle
        self.taskType = taskType
        self.createdAt = createdAt
        self.dbreferenceDocumentIdL = dbreferenceDocumentIdL
    }
   
    init(dict: [String: Any]) {
        self.taskTitle = dict["taskName"] as? String ?? "no task name"
        self.taskType = dict["taskType"] as? String ?? "no task type"
        self.createdAt = dict["taskTime"] as? String ?? "no creartion time"
        self.dbreferenceDocumentIdL = dict["dbReference"] as? String ?? "no dbReference"
    }
    
    public var dateFormattedString: String {
        let isoDateFormatter = ISO8601DateFormatter()
        var formattedDate = createdAt
        if let date = isoDateFormatter.date(from: createdAt) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy hh:mm a"
            formattedDate = dateFormatter.string(from: date)
        }
        return formattedDate
    }
    public var date: Date {
        let isoDateFormatter = ISO8601DateFormatter()
        var formattedDate = Date()
        if let date = isoDateFormatter.date(from: createdAt) {
            formattedDate = date
        }
        return formattedDate
    }

}
