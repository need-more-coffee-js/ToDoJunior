//
//  ViewController.swift
//  ToDoMVC
//
//  Created by Денис Ефименков on 30.03.2025.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var iconsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private let iconItem1: UIView = {
        let imageView = UIImageView(image: UIImage(systemName: "house.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        return imageView
    }()
    private let iconItem2: UIView = {
        let imageView = UIImageView(image: UIImage(systemName: "house.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        return imageView
    }()
    private let iconItem3: UIView = {
        let imageView = UIImageView(image: UIImage(systemName: "house.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Мои задачи"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 15
        return button
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["List", "Calendar"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        return control
    }()
    
    private let containerView = UIView()
    private var pageViewController: UIPageViewController!
    private var viewControllers: [UIViewController] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupPageViewController()
        setupStackViewIcons()
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
        headerView.addSubview(segmentedControl)
        view.addSubview(containerView)
        view.addSubview(footerView)
        footerView.addSubview(iconsStackView)
    }

    
    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
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
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        footerView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupStackViewIcons(){
        iconsStackView.addArrangedSubview(iconItem1)
        iconsStackView.addArrangedSubview(iconItem2)
        iconsStackView.addArrangedSubview(iconItem3)
        iconsStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
    }
    
    //MARK: - SAVE TASK BUTTON
    @objc func saveTask(){}
    
    private func setupPageViewController() {
        pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        pageViewController.setViewControllers(
            [viewControllers[0]],
            direction: .forward,
            animated: false
        )
        
        addChild(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        pageViewController.didMove(toParent: self)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        containerView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        containerView.addGestureRecognizer(swipeRight)
    }
    
    // MARK: - Actions
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        let direction: UIPageViewController.NavigationDirection = sender.selectedSegmentIndex == 0 ? .reverse : .forward
        pageViewController.setViewControllers(
            [viewControllers[sender.selectedSegmentIndex]],
            direction: direction,
            animated: true
        )
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        let currentIndex = segmentedControl.selectedSegmentIndex
        var newIndex = currentIndex
        
        switch gesture.direction {
        case .left where currentIndex < viewControllers.count - 1:
            newIndex = currentIndex + 1
        case .right where currentIndex > 0:
            newIndex = currentIndex - 1
        default:
            return
        }
        
        segmentedControl.selectedSegmentIndex = newIndex
        segmentChanged(segmentedControl)
    }
}

// MARK: - UIPageViewControllerDelegate & UIPageViewControllerDataSource
extension MainViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return viewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index < viewControllers.count - 1 else {
            return nil
        }
        return viewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let visibleVC = pageViewController.viewControllers?.first,
           let index = viewControllers.firstIndex(of: visibleVC) {
            segmentedControl.selectedSegmentIndex = index
        }
    }
}
