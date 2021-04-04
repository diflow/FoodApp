//
//  ViewController.swift
//  FoodApp
//
//  Created by ivan on 26.03.2021.
//

import UIKit
import SnapKit
import RxSwift

class HomeViewController: UIViewController {
    let filterVC = FilterViewController()
    let networkManager = NetworkManager()
    
    var restaurants = [Restaurant]()
    var filterRestaurants = [Restaurant]()
    
    let disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private lazy var filterView: UIView = {
        let view = UIView()
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(recognizer)
        view.backgroundColor = UIColor.App.blackSqueeze
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Усі способи отримання"
        return label
    }()
    
    private lazy var filterImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "allIcon")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchData()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = UIColor.App.bostonBlue
        navigationController?.navigationBar.topItem?.title = "Перемоги проспект 105, Чернігів"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let navigationBarHeight = navigationController?.navigationBar.bounds.height ?? 0
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        view.addSubview(filterView)
        filterView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(navigationBarHeight + statusBarHeight)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(filterView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        filterView.addSubview(filterImageView)
        filterImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(view.bounds.width * 0.04)
            $0.height.equalToSuperview().multipliedBy(0.5)
        }
        
        filterView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(view.bounds.width * 0.15)
            $0.height.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    private func fetchData() {
        networkManager.fetchRestaurants()
            .subscribe { [weak self] (restaurants) in
            guard let self = self else { return }
            self.restaurants = restaurants
            self.filterRestaurants = restaurants
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } onError: { (error) in
            print(error)
        }.disposed(by: self.disposeBag)
    }
    
    @objc func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        filterVC.delegate = self
        filterVC.setRestaurantsCountlabel(count: filterRestaurants.count)
        
        show(filterVC, sender: self)
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        let restaurant = filterRestaurants[indexPath.row]
        
        cell.configure(with: restaurant)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

// MARK: - FilterViewControllerDelegate
extension HomeViewController: FilterViewControllerDelegate {
    func filterRestaurants(currentFilter: FilterDetail) {
        filterImageView.image = UIImage(named: currentFilter.iconName)
        titleLabel.text = currentFilter.title
        
        if currentFilter.type == 0 {
            filterRestaurants = restaurants
        } else {
            filterRestaurants = restaurants.filter {
                guard let availableDeliveryTypes = $0.availableDeliveryTypes else { return false }
                return availableDeliveryTypes.contains(currentFilter.type - 1)
            }
        }
        filterVC.confirmFilterView.setRestaurantsCountlabel(count: filterRestaurants.count)
        
        tableView.reloadData()
    }
}
