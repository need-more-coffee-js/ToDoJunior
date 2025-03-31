//
//  EditTaskViewController.swift
//  ToDoMVC
//
//  Created by Денис Ефименков on 31.03.2025.
//
import UIKit
import SnapKit
import CoreData

class EditTaskViewController: UIViewController {
    
    var task: Task!
    let coreData = CoreDataStack.shared
    
    private lazy var titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Название задачи"
        tf.borderStyle = .roundedRect
        tf.text = task.title
        return tf
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 5
        tv.text = task.descriptionTask
        return tv
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextView)
        view.addSubview(saveButton)
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func saveChanges() {
        task.title = titleTextField.text
        task.descriptionTask = descriptionTextView.text
        coreData.saveContext()
        
        dismiss(animated: true, completion: nil)
    }
}
