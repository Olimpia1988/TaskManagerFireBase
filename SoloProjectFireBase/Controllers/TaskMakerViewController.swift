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
import UserNotifications


class TaskMakerViewController: UIViewController {
    
    private var datePicker = UIDatePicker()
    var example: Tasker!
    private var usersession: UserSession!
    let store = EKEventStore.init()
    private var task: Tasker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
      super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
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

            let dateFormatter = DateFormatter()
            print(datePicker.date)
            dateFormatter.dateFormat =  "MM/dd"
            let taskToSet = Tasker(taskTitle: eventName, taskType: description, createdAt: dateFormatter.string(from: datePicker.date), dbreferenceDocumentIdL: "")
            DatabaseManager.postSoloProjectDataBase(task: taskToSet)
            showAlert(title: "Task Added", message: "", style: .alert) { (alert) in
                self.dismiss(animated: true)
                
            }
            
            let content = UNMutableNotificationContent()
            content.sound = UNNotificationSound.default
            
            let dateToRemind = datePicker.date
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: dateToRemind)
            let minutes = calendar.component(.minute, from: dateToRemind)
            
            var dateComonents = DateComponents()
            dateComonents.hour = hour
            dateComonents.minute = minutes
            dateComonents.timeZone = TimeZone.current
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComonents, repeats: false)
             let request = UNNotificationRequest(identifier: "To do list Alert", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("adding notification error: \(error)")
                } else {
                    print("successfully added notification")
                }
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

            return cell
            
        } else if indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for:indexPath) as? ReminderCell else { return UITableViewCell() }
          
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


// local notifications: step 4 (optional)
// only if you want in-app notifications
extension TaskMakerViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
