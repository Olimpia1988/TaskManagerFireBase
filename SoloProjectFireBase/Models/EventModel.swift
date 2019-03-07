//
//  EventModel.swift
//  SoloProjectFireBase
//
//  Created by Olimpia on 2/28/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import Foundation
import UIKit

final class Tasks {
    private static var tasks = [Tasker]()
    
    static func arrayOfTasks() -> [Tasker] {
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename).path
        if FileManager.default.fileExists(atPath: path) {
            if let data = FileManager.default.contents(atPath: path) {
                do {
                    tasks = try PropertyListDecoder().decode([Tasker].self, from: data)
                } catch {
                    print("error: \(error)")
                }
            } else {
                print(" Data is nil ")
            }
        } else {
            print("\(filename) does not exist")
        }
        
        tasks = tasks.sorted { $0.date > $1.date }
        return tasks
        
      
    }
    
    private static let filename = "SoloProjectFireBase.plist" // get the name of the info plist here
    private init() {}

    static func saveTask() {
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename)
        do {
            let data = try PropertyListEncoder().encode(tasks)
            try data.write(to: path, options: Data.WritingOptions.atomic)
        } catch {
            print("property list encoding error: \(error)")
        }
    }
    
    static func editTask(task: Tasker, atIndex index: Int) {
        tasks.remove(at: index)
        tasks.insert(task, at: index)
        tasks.sorted{$0.date > $1.date}
    }
    
    static func getTasks() -> Tasker? {
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename).path
        var taskToGet: Tasker?
        if FileManager.default.fileExists(atPath: path) {
            if let data = FileManager.default.contents(atPath: path) {
                do {
                   taskToGet = try PropertyListDecoder().decode(Tasker.self, from: data)
                } catch {
                    print("\(error)")
                }
            } else {
                print("data is nill")
            }
        } else {
            print("no file name")
        }
        return taskToGet
    }
    
    static func addTask(task: Tasker) {
        tasks.append(task)
        saveTask()
    }
    
    static func deleteFromSettings(atIndex index: Int) {
        tasks.remove(at: index)
        saveTask()
    }
    
    static func update(task: Tasker, index: Int) {
        tasks[index] = task
        saveTask()
    }
    
}
