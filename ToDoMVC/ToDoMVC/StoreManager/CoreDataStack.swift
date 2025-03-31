//
//  CoreDataStack.swift
//  ToDoMVC
//
//  Created by Денис Ефименков on 30.03.2025.
//

import Foundation
import CoreData


import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoMVC")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do{
                try context.save()
            }catch let error as NSError{
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    func getFetchResultsController(entityName: String, keyForSort: String) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: keyForSort, ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "sectionIdentifier",
            cacheName: nil
        )
        
        return fetchedResultsController
    }
    
    func saveMyTask(descriptionForTask: String, title: String,createdAt: Date, plannedDate: Date,isCompleted: Bool = false){
        let newTask = Task(context: context)
        newTask.descriptionTask = descriptionForTask
        newTask.createdAt = createdAt
        newTask.isCompleted = isCompleted
        newTask.title = title
        newTask.plannedDate = plannedDate
        saveContext()
    }

}
extension Task {
    @objc var sectionIdentifier: String {
        guard let date = self.value(forKey: "createdAt") as? Date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
