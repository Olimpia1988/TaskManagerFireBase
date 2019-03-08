//
//  EditViewController.swift
//  SoloProjectFireBase
//
//  Created by Olimpia on 3/8/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import FirebaseFirestore


class EditViewController: UIViewController {
    
    private var datePicker = UIDatePicker()
    private var currentTask = [Tasker]() {
        didSet {
            view.reloadInputViews()
        }
    }
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var taskName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFBData()
        
        
        
    }
    
  private func getFBData() {
        DatabaseManager.firebaseDB.collection(DatabaseKeys.TaskCollectionKey).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
            } else if let snapshot = snapshot {
                for document in snapshot.documents {
                    let task = Tasker(dict: document.data())
                    self.currentTask.append(task)
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat =  "yyyy-MM-dd HH:mm"
                self.taskName.text = self.currentTask[0].taskTitle
                self.textField.text = self.currentTask[0].taskType
                self.date.inputView = self.datePicker
            
                
                dump(self.currentTask)
            }
        }
        
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let nameToSave = self.taskName.text
        let descToSave = self.textField.text
        let timeToSave = self.date.text
        
        let taskToSave = Tasker(taskTitle: nameToSave!, taskType: descToSave!, createdAt: timeToSave!, dbreferenceDocumentIdL: "")
        DatabaseManager.postSoloProjectDataBase(task: taskToSave)
        showAlert(title: "Changes saved", message: "", style: .alert) { (alert) in
               self.dismiss(animated: true, completion: nil)
        }
     
        
    }
}
