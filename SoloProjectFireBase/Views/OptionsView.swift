//
//  OptionsView.swift
//  SoloProjectFireBase
//
//  Created by Olimpia on 2/27/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import UIKit

class OptionsView: UIView {

    lazy var view: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        addSubview(view)
//        backgroundColor = .blue
        setConstrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstrains() {
        view.translatesAutoresizingMaskIntoConstraints = false
        [view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0), view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0), view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -230), view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0)].forEach{ $0.isActive = true }
    }
    
}
