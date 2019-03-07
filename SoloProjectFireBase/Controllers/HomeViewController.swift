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
    @IBOutlet weak var selectedDateLabel: UILabel!
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
        
//        myCollectionView.scrollToItem(at:IndexPath(item: 2, section: 0), at: .right, animated: false)
//        UIView.animate(withDuration: 2, delay: 0, options: [.beginFromCurrentState],
//                       animations: {
//                        self.dateLabel.frame.origin.x -= 200
//                        self.view.layoutIfNeeded()
//        }, completion: nil)
        let today = Date()
        let weekday = Calendar.current.component(.weekday, from: today)
        let month = Calendar.current.component(.month, from: today)
        let date = Calendar.current.component(.day, from: today)
        dateLabel.text = "\(Calendar.current.weekdaySymbols[month-1]) \(Calendar.current.shortMonthSymbols[month-1]) \(date)"
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFBData()
    }
    
  
   private func getFBData() {
    DatabaseManager.firebaseDB.collection(DatabaseKeys.TaskCollectionKey).addSnapshotListener { (snapshot, error) in
        if let error = error {
            print(error)
        } else if let snapshot = snapshot {
            for document in snapshot.documents {
                let currentTask = Tasker(dict: document.data())
                self.tasksToSet.append(currentTask)
            }
            
        }
     }
    
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasksToSet.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as? HomeCell else { return UICollectionViewCell() }
        cell.taskName.text = self.calendarArray[indexPath.row] as? String
        cell.textFied.text = tasksToSet[indexPath.row].taskType
        cell.taskName.text = tasksToSet[indexPath.row].taskTitle
        
        
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let size = CGSize(width: 410, height: 500)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        guard let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as? HomeCell else { return }
        
        guard let taskName = cell.textFied.text else {
            return
        }
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
