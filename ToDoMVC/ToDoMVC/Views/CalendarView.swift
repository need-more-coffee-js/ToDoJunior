//
//  SecondViewController.swift
//  ToDoMVC
//
//  Created by Денис Ефименков on 30.03.2025.
//

import UIKit
import SnapKit
import FSCalendar

class CalendarView: UIViewController {
    
    // MARK: - UI Elements
    private lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .month
        calendar.appearance.headerTitleColor = .systemBlue
        calendar.appearance.weekdayTextColor = .systemBlue
        calendar.appearance.todayColor = .systemBlue.withAlphaComponent(0.3)
        calendar.appearance.selectionColor = .systemBlue
        calendar.appearance.titleDefaultColor = .label
        calendar.appearance.titleWeekendColor = .systemRed
        return calendar
    }()
    
    private lazy var eventsLabel: UILabel = {
        let label = UILabel()
        label.text = "События на выбранную дату:"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var eventsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EventCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        return tableView
    }()
    
    // MARK: - Data
    private var events: [String: [String]] = [:]
    private var selectedDate: Date = Date()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupSampleData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(calendar)
        view.addSubview(eventsLabel)
        view.addSubview(eventsTableView)
    }
    
    private func setupConstraints() {
        calendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(300)
        }
        
        eventsLabel.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        eventsTableView.snp.makeConstraints { make in
            make.top.equalTo(eventsLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupSampleData() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        //MARK: - заглушка пока нет бд
        events = [
            formatter.string(from: Date()): ["Событие 1", "Событие 2"],
            formatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: Date())!): ["Важная встреча"]
        ]
    }
}

// MARK: - FSCalendarDelegate & FSCalendarDataSource
extension CalendarView: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        eventsTableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        return events[dateString]?.count ?? 0
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension CalendarView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: selectedDate)
        return events[dateString]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: selectedDate)
        
        if let event = events[dateString]?[indexPath.row] {
            cell.textLabel?.text = event
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
