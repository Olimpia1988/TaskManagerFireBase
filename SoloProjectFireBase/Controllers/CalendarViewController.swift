//
//  CalendarViewController.swift
//  SoloProjectFireBase
//
//  Created by Olimpia on 3/1/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import UIKit
import JTAppleCalendar



class CalendarViewController: UIViewController {
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    let uotsideMonthColor: UIColor = #colorLiteral(red: 0.8224461675, green: 0.8175580502, blue: 0.8262042403, alpha: 1)
    let monthColor = UIColor.white
    let selectedMonthColor: UIColor = #colorLiteral(red: 0.4773904085, green: 0.3207951784, blue: 0.6541602612, alpha: 1)
    let currentDateSelectedViewColor: UIColor = #colorLiteral(red: 0.6677607894, green: 0.5491837859, blue: 0.9152842164, alpha: 1)
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
    
    }
    func setupCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        //set it up here with a completion handler
        
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell else { return }
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            } else {
                validCell.dateLabel.textColor = uotsideMonthColor
            }
        }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell else { return }
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func setupViewsOfCalendar(from visibleDate: DateSegmentInfo) {
        let date = visibleDate.monthDates.first!.date
        self.formatter.dateFormat = "yyyy"
        self.yearLabel.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.monthLabel.text = self.formatter.string(from: date)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = formatter.date(from: "2019 01 01")
        let endDate = formatter.date(from: "2019 12 31")
        
        let parameter = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        return parameter
    }
    
}
extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
    handleCellSelected(view: cell, cellState: cellState)
            handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
    handleCellSelected(view: cell, cellState: cellState)
            handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
      setupViewsOfCalendar(from: visibleDates)
    }
    
}
