//
//  FirstViewController.swift
//  ToDoMVC
//
//  Created by Денис Ефименков on 30.03.2025.
//

import UIKit
import SnapKit

class ListView: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TaskCustomCell.self, forCellReuseIdentifier: TaskCustomCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
        return tableView
    }()
    //MARK: - ЗАГЛУШКА ПОКА НЕТ БД
    private var dataModel: [DataModel] = [
        DataModel(title: "Купить продукты", taskDescription: "Молоко, хлеб, яйца"),
        DataModel(title: "Реализовать паттеры", taskDescription: "MVC,MVVM, VIPER"),
        DataModel(title: "Позвонить жене", taskDescription: "Обсудить выходные")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCustomCell.reuseIdentifier, for: indexPath) as! TaskCustomCell
        cell.configure(with: dataModel[indexPath.row])
        return cell
    }
}
