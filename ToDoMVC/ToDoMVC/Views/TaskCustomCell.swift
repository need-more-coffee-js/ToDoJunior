//
//  TaskCustomCell.swift
//  ToDoMVC
//
//  Created by Денис Ефименков on 30.03.2025.
//

import UIKit
import SnapKit

class TaskCustomCell: UITableViewCell {
    static let reuseIdentifier = "TaskCustomCell"
    
    private let circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    public let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        circleView.addSubview(dayLabel)
        circleView.addSubview(monthLabel)
        contentView.addSubview(circleView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        circleView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalToSuperview().multipliedBy(0.9)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-8)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalTo(circleView.snp.trailing).offset(8)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(circleView.snp.trailing).offset(8)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func configure(with task: Task) {
        titleLabel.text = task.title
        descriptionLabel.text = task.descriptionTask
        
        if let createdAt = task.createdAt {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day, .month], from: createdAt)
            
            dayLabel.text = "\(components.day ?? 0)"
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.dateFormat = "MMM"
            monthLabel.text = dateFormatter.string(from: createdAt).capitalized
        }
        
        let isCompleted = task.isCompleted
        titleLabel.textColor = isCompleted ? .lightGray : .darkText
        descriptionLabel.textColor = isCompleted ? .lightGray : .darkGray
        circleView.backgroundColor = isCompleted ? .systemGray4 : .systemGreen
    }
}
