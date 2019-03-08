//
//  HomeCell.swift
//  SoloProjectFireBase
//
//  Created by Olimpia on 3/3/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import UIKit

protocol HomeCellDelegate: AnyObject {
    func willDeleteTasker(_ homeCell: HomeCell, tasker: Tasker)
}

class HomeCell: UICollectionViewCell {
    
    private var currentTask: Tasker!
    
    weak var delegate: HomeCellDelegate?
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var textFied: UITextView!
    @IBOutlet weak var editButon: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var delete: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        delete.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)

    }
    
    public func configureCell(tasker: Tasker) {
        currentTask = tasker
        taskName.text = tasker.taskTitle
        textFied.text = tasker.taskType
    }
    
    @objc private func deleteAction() {
        delegate?.willDeleteTasker(self, tasker: currentTask)
    }
    
    
}
