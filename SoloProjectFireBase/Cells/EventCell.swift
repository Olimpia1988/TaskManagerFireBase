//
//  EventCell.swift
//  SoloProjectFireBase
//
//  Created by Olimpia on 2/27/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import UIKit


protocol EventCellDelegate: AnyObject {
    func getInputser(eventName: String, eventNote: String)
}

class EventCell: UITableViewCell {

    weak var delegate: EventCellDelegate?
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventNotes: UITextView!
    
  
    
}
