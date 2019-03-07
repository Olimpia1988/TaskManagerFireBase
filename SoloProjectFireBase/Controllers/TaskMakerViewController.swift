//
//  TaskMakerViewController.swift
//  SoloProjectFireBase
//
//  Created by Olimpia on 2/25/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class TaskMakerViewController: UIViewController {
    
    private var datePicker = UIDatePicker()
    var example: Tasker!
    private var usersession: UserSession!
    private var taskType = [TaskType]()
    private var selectedTasksType = "\(TaskType.allCases[0])"
    let store = EKEventStore.init()
    
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var newTaskLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
      super.viewDidLoad()
        
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:text:textField:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRec:)))
        view.addGestureRecognizer(tapGesture)
       
        saveButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
       store.requestAccess(to: .event) { (granted, error) in
            if let error = error {
                self.showAlert(title: "Error accessing calendar", message: error.localizedDescription, actionTitle: "Ok")
                print("request acces error: \(error)")
            } else if granted {
                print("acces granted")
            } else {
                print("acces denied")
            }
        }
    }
    
    @objc func saveTask() {
        let indexPath = IndexPath(item: 1, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? EventCell {
            guard let eventName = cell.eventName.text,
                let description = cell.eventNotes.text,
                !eventName.isEmpty,
                !description.isEmpty else {
                     showAlert(title: "Missing Fields", message: "Name and description of the task in required", actionTitle: "Try Again")
                    return
            }
            cell.delegate?.getInputser(eventName: cell.eventName.text!, eventNote: cell.eventNotes.text) // to send to view home view controller
            let dateFormatter = DateFormatter()
            print(datePicker.date)
            dateFormatter.dateFormat =  " yyyy-MM-dd HH:mm "
            let taskToSet = Tasker(taskTitle: eventName, taskType: description, createdAt: dateFormatter.string(from: datePicker.date), dbreferenceDocumentIdL: "")
            DatabaseManager.postSoloProjectDataBase(task: taskToSet)
            
            showAlert(title: "Task Added", message: "", style: .alert) { (alert) in
                self.dismiss(animated: true)
            }
        }
        
    }
    
    @objc func viewTapped(gestureRec: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker, text: String, textField: UITextField) {
        let indexPath = IndexPath(item: 2, section: 0) // index 2 refers to the EventSetupCell
        if let cell = tableView.cellForRow(at: indexPath) as? EventSetupCell { // we are casting to an EventSetupCell
            let dateFormatter = DateFormatter()
            print(datePicker.date)
            dateFormatter.dateFormat =  " yyyy-MM-dd HH:mm "
            if cell.startTextField.isFirstResponder {
                cell.startTextField.text = dateFormatter.string(from: datePicker.date)
            } else {
                cell.endTextField.text = dateFormatter.string(from: datePicker.date)
            }
        }

    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    }
    


extension TaskMakerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellImage", for: indexPath) as? CellImage else { return UITableViewCell() }
            //image from profile seetings go here
      
            return cell
      
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventCell else { return UITableViewCell() }
            
        
           
          return cell
            
} else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventSetupCell", for: indexPath) as? EventSetupCell else { return UITableViewCell()}
            
            cell.startTextField.inputView = datePicker
            cell.endTextField.inputView = datePicker
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            print("\(dateFormatter.dateFormat)")

      
            return cell
            
        } else if indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for:indexPath) as? ReminderCell else { return UITableViewCell() }
          
            return cell
            
            
        } else if indexPath.row == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NoteCell else { return UITableViewCell() }
          
            return cell 
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}

extension TaskMakerViewController: EventCellDelegate {
    func getInputser(eventName: String, eventNote: String) {
        print("\(eventName) \(eventNote)")
        
    }
    
    
}


