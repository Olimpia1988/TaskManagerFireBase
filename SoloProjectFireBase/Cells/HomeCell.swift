//
//  HomeCell.swift
//  SoloProjectFireBase
//
//  Created by Olimpia on 3/3/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import UIKit

protocol HomeCellDelegate: AnyObject {
    func getDataFromUser(taskName: String, taskDescription: String)
}

class HomeCell: UICollectionViewCell {
    
    weak var delegate: HomeCellDelegate?
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var textFied: UITextView!
    
    
}
