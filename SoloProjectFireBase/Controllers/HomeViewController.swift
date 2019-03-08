//
//  HomeViewController.swift
//  SoloProjectFireBase
//
//  Created by Olimpia on 2/25/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import FirebaseFirestore



class HomeViewController: UIViewController  {
    
    private var tasksToSet = [Tasker]() {
        didSet {
            myCollectionView.reloadData()
        }
    }
    
    
    private var listener: ListenerRegistration!
    @IBOutlet weak var myCollectionView: UICollectionView!
    var optionsView = OptionsView()
    var selectedDate = Date()
    @IBOutlet weak var dateLabel: UILabel!
    var calendarArray = [Date]() as NSArray
   
   
    
    @IBAction func calendar(_ sender: UIBarButtonItem) {
        let CalendarViewController = self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        CalendarViewController.modalPresentationStyle = .overCurrentContext
        self.present(CalendarViewController, animated: false, completion: nil)
    }
    
 
    
    func didSelectDate(date: Date) {
        selectedDate = date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFBData()
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        self.calendarArray = getCalendar.arrayOfDates()
        let today = Date()
        let weekday = Calendar.current.component(.weekday, from: today)
        let month = Calendar.current.component(.month, from: today)
        let date = Calendar.current.component(.day, from: today)
        dateLabel.text = "\(Calendar.current.weekdaySymbols[weekday-1]) \(Calendar.current.shortMonthSymbols[month-1]) \(date)"
    }
    
    
    @IBAction func editAction(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "TaskStoryBoard", bundle: nil)
        
        let EditVC = storyBoard.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        EditVC.modalPresentationStyle = .overCurrentContext
        self.present(EditVC, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    
//
//    func deleteTask() {
//        let indexPath = IndexPath(item: 0, section: 0)
//        if let cell = myCollectionView.cellForItem(at: indexPath) as? HomeCell {
//            let buttonToDelete = cell.delete
//            buttonToDelete?.addTarget(self, action: #selector(deleteCurrentTaks), for: .touchUpInside)
//
//        }
//    }
    
//    @objc func deleteCurrentTaks() {
//    let indexPath = IndexPath(item: 1, section: 0)
//        if let cell = myCollectionView.cellForItem(at: indexPath) as? HomeCell {
//            let eventName = cell.taskName.text
//            let description = cell.textFied.text
//            let date = cell.date.text
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//            let taskToDelete = Tasker(taskTitle: eventName!, taskType: description!, createdAt: date!, dbreferenceDocumentIdL: "")
//            DatabaseManager.firebaseDB
//                .collection(DatabaseKeys.TaskCollectionKey)
//                .document(taskToDelete.dbreferenceDocumentIdL)
//                .delete { (error) in
//                    if let error = error {
//                        print("failed to delete with error: \(error)")
//                    } else {
//                        print("deleted successfully")
//                    }
//            }
//        }
//    }

    
    private func getFBData() {
DatabaseManager.firebaseDB.collection(DatabaseKeys.TaskCollectionKey).addSnapshotListener { (snapshot, error) in
        if let error = error {
            print(error)
        } else if let snapshot = snapshot {
            self.tasksToSet.removeAll()
            for document in snapshot.documents {
                let currentTask = Tasker(dict: document.data())
                self.tasksToSet.append(currentTask)
            }
            dump(self.tasksToSet)
        }
     }
    
    }
    
    func editContent() {
        let indexPath = IndexPath(item: 0, section: 0)
        if let cell = myCollectionView.cellForItem(at: indexPath) as? HomeCell {
             let button = cell.editButon
            button?.addTarget(self, action: #selector(editor), for: .touchUpInside)
        }
    }
    
    @objc func editor() { //present the task maker , state where im editing or creating
        let EditVC = self.storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        EditVC.modalPresentationStyle = .overCurrentContext
        self.present(EditVC, animated: true, completion: nil)
        
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasksToSet.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as? HomeCell else { return UICollectionViewCell() }
        let tasker = tasksToSet[indexPath.row]
        cell.configureCell(tasker: tasker)
        cell.date.text = self.calendarArray[indexPath.row] as? String
        cell.delegate = self
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let size = CGSize(width: 410, height: 500)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       

    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension HomeViewController: HomeCellDelegate  {
    func willDeleteTasker(_ homeCell: HomeCell, tasker: Tasker) {
        DatabaseManager.firebaseDB
            .collection(DatabaseKeys.TaskCollectionKey)
            .document(tasker.dbreferenceDocumentIdL)
            .delete { (error) in
                if let error = error {
                    print("failed to delete with error: \(error)")
                } else {
                    print("deleted successfully")
                }
        }
    }
}
