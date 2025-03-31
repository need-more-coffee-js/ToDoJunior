//
//  ViewController.swift
//  ToDoMVC
//
//  Created by Денис Ефименков on 30.03.2025.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    let coreDataSource = CoreDataStack.shared.getFetchResultsController(entityName: "Task", keyForSort: "createdAt")
    let taskFetch = CoreDataStack.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupPageViewController()
        setupStackViewIcons()
        setupButtonsActions()
        setupSwipeGestures()
        selectViewController(at: 0, animated: false)
    }
    // MARK: - UI Elements
    private let containerView = UIView()
    private var pageViewController: UIPageViewController!
    private var viewControllers: [UIViewController] = []
    private var currentIndex = 0 {
        didSet{
            updateFooterButtons()
        }
    }
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(showModalButtonTapped), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 15
        return button
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.shadowColor = UIColor.black.cgColor
        return view
    }()
    
    private lazy var iconsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        //label.text = "Мои задачи"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private lazy var listButton: UIButton = createFooterButton(iconName:"list.bullet" , index: 0)
    private lazy var calendarButton: UIButton = createFooterButton(iconName:"calendar" , index: 1)
    private lazy var timeTableButton: UIButton = createFooterButton(iconName:"person.crop.circle.badge.clock" , index: 2)
    

    //MARK: - Button action
    func setupButtonsActions(){
        listButton.addTarget(self, action: #selector(saveTaskprint), for: .touchUpInside)
        calendarButton.addTarget(self, action: #selector(saveTaskprint), for: .touchUpInside)
        timeTableButton.addTarget(self, action: #selector(saveTaskprint), for: .touchUpInside)
    }
    // MARK: - Setup and Constraints
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        let firstVC = ListView()
        let secondVC = CalendarView()
        viewControllers = [firstVC, secondVC]
        
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(addButton)
        view.addSubview(containerView)
        view.addSubview(footerView)
        footerView.addSubview(iconsStackView)
    }

    
    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(20)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-20)
            make.height.width.equalTo(30)
        }

        containerView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(footerView.snp.topMargin)
        }
        footerView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.1)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalToSuperview()
        }
    }
    
    private func setupStackViewIcons(){
        iconsStackView.addArrangedSubview(listButton)
        iconsStackView.addArrangedSubview(calendarButton)
        iconsStackView.addArrangedSubview(timeTableButton)
        iconsStackView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    //MARK: - SAVE TASK BUTTON
    @objc func saveTaskprint(){
        print("press icon list")
    }
    @objc func addButtonSave(){
        
    }
    @objc private func showModalButtonTapped() {
        let modalViewController = BottomModalViewController()
        modalViewController.modalPresentationStyle = .overCurrentContext
        self.present(modalViewController, animated: false, completion: nil)
    }
    
    private func setupPageViewController() {
        pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        viewControllers = [
            ListView(),
            CalendarView()
        ]
        
        addChild(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        pageViewController.didMove(toParent: self)
    }
    //MARK: - Create footer button
    private func createFooterButton(iconName: String, index: Int) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: iconName),for: .normal)
        button.tintColor = index == 0 ? .systemBlue : .systemGray
        button.tag = index
        button.addTarget(self, action: #selector(footerButtonTapped(_ :)), for: .touchUpInside)
        return button
    }
    //MARK: - Swipe setup
    private func setupSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        containerView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        containerView.addGestureRecognizer(swipeRight)
    }
    
    // MARK: - Actions
    @objc private func footerButtonTapped(_ sender: UIButton) {
        // Анимация нажатия
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = .identity
            }
        }
        
        selectViewController(at: sender.tag, animated: true)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        var newIndex = currentIndex
        
        switch gesture.direction {
        case .left where currentIndex < viewControllers.count - 1:
            newIndex = currentIndex + 1
        case .right where currentIndex > 0:
            newIndex = currentIndex - 1
        default:
            return
        }
        
        selectViewController(at: newIndex, animated: true)
    }
    
    private func selectViewController(at index: Int, animated: Bool) {
        guard index != currentIndex, index >= 0, index < viewControllers.count else { return }
        
        let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
        currentIndex = index
        
        pageViewController.setViewControllers(
            [viewControllers[index]],
            direction: direction,
            animated: animated,
            completion: nil
        )
        switch index {
        case 0:
            titleLabel.text = "List"
        case 1:
            titleLabel.text = "Calendar"
        case 2:
            titleLabel.text = "Time Table"
        default :
            break
        }
        
        updateFooterButtons()
    }
    
    private func updateFooterButtons() {
        UIView.animate(withDuration: 0.3) {
            self.listButton.tintColor = self.currentIndex == 0 ? .systemBlue : .gray
            self.calendarButton.tintColor = self.currentIndex == 1 ? .systemBlue : .gray
            self.timeTableButton.tintColor = self.currentIndex == 2 ? .systemBlue : .gray
            
            [self.listButton, self.calendarButton, self.timeTableButton].forEach { button in
                button.transform = button.tag == self.currentIndex ?
                    CGAffineTransform(scaleX: 1.1, y: 1.1) : .identity
            }
        }
    }
}
//MARK: - PAGE VIEW EXTENSION
extension MainViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index > 0 else { return nil }
        return viewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index < viewControllers.count - 1 else { return nil }
        return viewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleVC = pageViewController.viewControllers?.first, let index = viewControllers.firstIndex(of: visibleVC) {
            currentIndex = index
            updateFooterButtons()
        }
    }
}
