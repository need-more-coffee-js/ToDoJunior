//
//  FirstViewController.swift
//  ToDoMVC
//
//  Created by Денис Ефименков on 30.03.2025.
//

import UIKit
import SnapKit
import CoreData

class ListView: UIViewController {
    
    let dataSource = CoreDataStack.shared.getFetchResultsController(entityName: "Task", keyForSort: "createdAt")
    let dateFormatter = DateFormatter()
    let data = CoreDataStack.shared
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TaskCustomCell.self, forCellReuseIdentifier: TaskCustomCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        view.addSubview(tableView)
        fetchTask()
        dataSource.delegate = self
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func reloadData(){
        tableView.reloadData()
    }
    private func fetchTask() {
        do {
            try dataSource.performFetch()
        } catch {
            print("Fetching Error: \(error)")
        }
    }
}

extension ListView: UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCustomCell.reuseIdentifier, for: indexPath) as! TaskCustomCell
        if let task = dataSource.object(at: indexPath) as? Task {
            cell.configure(with: task)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = dataSource.sections?[section],
              let firstObject = sectionInfo.objects?.first as? Task,
              let date = firstObject.value(forKey: "createdAt") as? Date else {
            return nil
        }
        return dateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let taskToDelete = dataSource.object(at: indexPath) as? Task else { return }
            
            CoreDataStack.shared.context.delete(taskToDelete)
            CoreDataStack.shared.saveContext()
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let taskToEdit = dataSource.object(at: indexPath) as? Task else { return }
        showEditTaskViewController(for: taskToEdit)
    }
    
    private func showEditTaskViewController(for task: Task) {
        let editVC = EditTaskViewController()
        editVC.task = task

        present(editVC, animated: true)
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .normal, title: "Готово") { [weak self] (_, _, completion) in
            self?.toggleTaskCompletion(at: indexPath)
            completion(true)
        }
        
        completeAction.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [completeAction])
    }
    
    private func toggleTaskCompletion(at indexPath: IndexPath) {
        guard let task = dataSource.object(at: indexPath) as? Task else { return }
        task.isCompleted.toggle()
        CoreDataStack.shared.saveContext()
        tableView.reloadData()
    }
    

    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default: break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
