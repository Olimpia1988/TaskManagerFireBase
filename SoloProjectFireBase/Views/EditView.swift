//
//  EditView.swift
//  SoloProjectFireBase
//
//  Created by Olimpia on 3/8/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import Foundation
import UIKit

class EditView: UIView {
    
    lazy var editView: UIView = {
        let editView = UIView()
        return editView
    }()
    
    lazy var taskName: UILabel = {
        let taskName = UILabel()
    taskName.textColor = .black
        taskName.text = "name of task"
        
        return taskName
    }()
    
    lazy var taskDescription: UITextField = {
        let taskDescription = UITextField()
        taskDescription.placeholder = "Edit your task"
        return taskDescription
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        addSubview(editView)
        addSubview(taskName)
        addSubview(taskDescription)
        setConstrains()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstrains() {
        editView.translatesAutoresizingMaskIntoConstraints = false
        [editView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30), editView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15), editView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: -15), editView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)].forEach{ $0.isActive = true }
        
        taskName.translatesAutoresizingMaskIntoConstraints = false
        [taskName.topAnchor.constraint(equalTo: editView.topAnchor, constant: 22), taskName.trailingAnchor.constraint(equalTo: editView.leadingAnchor, constant: 22), taskName.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.5), taskName.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.75)].forEach{ $0.isActive = true }
        
        
    }
}
