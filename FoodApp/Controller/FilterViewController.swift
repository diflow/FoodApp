//
//  FilterViewController.swift
//  FoodApp
//
//  Created by ivan on 28.03.2021.
//

import UIKit
import RxSwift

protocol FilterViewControllerDelegate: class {
    func filterRestaurants(currentFilter: FilterDetail)
}

class FilterViewController: UIViewController {
    let confirmFilterView = ConfirmFilterView()
    let networkManager = NetworkManager()
    let disposeBag = DisposeBag()
    
    var currentFilter = FilterDetail(title: "Усі способи отримання", iconName: "allIcon", type: 0)
    
    lazy var filterDetails: [FilterDetail] = {
        return [currentFilter]
    }()
    
    weak var delegate: FilterViewControllerDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        
        tableView.register(UINib.init(nibName: "FilterTableViewCell", bundle: nil), forCellReuseIdentifier: "FilterTableViewCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchData()
        
        confirmFilterView.button.addTarget(self, action: #selector(confirmFilter), for: .touchUpInside)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.tintColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(2.2)
        }
        
        view.addSubview(confirmFilterView)
        confirmFilterView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.15)
        }
    }
    
    private func fetchData() {
        networkManager.fetchDeliveryData()
            .subscribe { [weak self] (deliveryData) in
                guard let self = self else { return }
                self.filterDetails.append(contentsOf: deliveryData.map { FilterDetail(title: $0.title, iconName: self.getIconName(type: $0.type + 1), type: $0.type + 1) })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } onError: { (error) in
                print(error)
            }.disposed(by: self.disposeBag)
    }
    
    func setRestaurantsCountlabel(count: Int) {
        confirmFilterView.setRestaurantsCountlabel(count: count)
    }
    
    func getIconName(type: Int) -> String {
        switch type {
        case 1:
            return "homeDeliveryIcon"
        case 2:
            return "doorDeliveryIcon"
        case 3:
            return "pickupIcon"
        case 4:
            return "bookingIcon"
        default:
            return ""
        }
    }
    
    @objc func confirmFilter() {
        delegate?.filterRestaurants(currentFilter: currentFilter)
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate
extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentFilter = filterDetails[indexPath.row]
        
        delegate?.filterRestaurants(currentFilter: currentFilter)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? FilterTableViewCell else { return }
        cell.checkImageView.image = UIImage(named: "check")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FilterTableViewCell else { return }
        cell.checkImageView.image = UIImage(named: "uncheck")
    }
}

// MARK: - UITableViewDataSource
extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell", for: indexPath) as! FilterTableViewCell
        
        cell.titleLabel.text = filterDetails[indexPath.row].title
        cell.imageView?.image = UIImage(named: filterDetails[indexPath.row].iconName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height * 0.15
    }
}
