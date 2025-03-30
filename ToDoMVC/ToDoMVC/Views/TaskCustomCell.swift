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
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.backgroundColor = .green
        return view
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(circleView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        circleView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
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
    
    func configure(with dataModel: DataModel) {
        titleLabel.text = dataModel.title
        descriptionLabel.text = dataModel.taskDescription
    }
}
