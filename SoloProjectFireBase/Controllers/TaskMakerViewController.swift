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
    
    var example : Tasker!
    
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
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:text:textField:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRec:)))
        view.addGestureRecognizer(tapGesture)
        
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
    
    @objc func viewTapped(gestureRec: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker, text: String, textField: UITextField) {
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        textField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
        
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

            if saveButton.isEnabled {
                // here is where things happend
                guard let eventName = cell.eventName.text,
                let description = cell.eventNotes.text,
                !eventName.isEmpty,
                !description.isEmpty else {
                   showAlert(title: "Missing Fiel", message: "", actionTitle: "OK")
                  
                    return cell }
            cell.delegate?.getInputser(eventName: eventName, eventNote: description)
            cell.delegate = self
             showAlert(title: "Missing Fields", message: "Task name requieres", actionTitle: "Try again")
            if eventName.isEmpty && description.isEmpty == false {
                    let taskToCreate = Tasker(taskTitle: eventName , taskType: description, dbreferenceDocumentIdL: "")
                    DatabaseManager.postRaceReviewToDatabase(task: taskToCreate)
            } else {
                  showAlert(title: "Task Created", message: "", actionTitle: "Ok")
                        self.dismiss(animated: true)
            }
            
            }
} else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventSetupCell", for: indexPath) as? EventSetupCell else { return UITableViewCell()}
            
            cell.startTextField.inputView = datePicker
            cell.endTextField.inputView = datePicker
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            //come back here!!
            dateChanged(datePicker: datePicker, text: dateFormatter.string(from: datePicker.date), textField: cell.startTextField!)
            dateChanged(datePicker: datePicker, text: dateFormatter.string(from: datePicker.date), textField: cell.endTextField)

      
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

