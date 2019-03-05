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

class HomeViewController: UIViewController  {
   
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
       // selectedDateLabel.isHidden = false
//        selectedDateLabel.text = date.getTitleDateFC()
    }
    
    override func viewDidLoad() {
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        super.viewWillAppear(true)
        self.calendarArray = getCalendar.arrayOfDates()
       myCollectionView.scrollToItem(at:IndexPath(item: 2, section: 0), at: .right, animated: false)
        
         super.viewDidLoad()
        UIView.animate(withDuration: 5, delay: 0, options: [.beginFromCurrentState],
                       animations: {
                        self.dateLabel.frame.origin.x -= 100
                        self.view.layoutIfNeeded()
        }, completion: nil)
        let today = Date()
        let weekday = Calendar.current.component(.weekday, from: today)
        let month = Calendar.current.component(.month, from: today)
        let date = Calendar.current.component(.day, from: today)
        dateLabel.text = "\(Calendar.current.weekdaySymbols[month-1]) \(Calendar.current.shortMonthSymbols[month-1]) \(date)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  
    
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as? HomeCell else { return UICollectionViewCell() }
        cell.taskName.text = self.calendarArray[indexPath.row] as? String
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let size = CGSize(width: 344, height: 400)
        return size
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
