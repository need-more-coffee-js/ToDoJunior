//
//  SecondViewController.swift
//  ToDoMVC
//
//  Created by Денис Ефименков on 30.03.2025.
//

import UIKit
import SnapKit

class CalendarView: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Calendar"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
