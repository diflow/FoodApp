//
//  CustomTableViewCell.swift
//  FoodApp
//
//  Created by ivan on 27.03.2021.
//

import UIKit
import SDWebImage

class CustomTableViewCell: UITableViewCell {
    
    private lazy var titleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.App.blackSqueeze
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.App.bilbao
        return label
    }()
    
    private lazy var restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.App.bilbao
        return label
    }()
    
    private lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "Без націнок"
        return label
    }()
    
    private lazy var actionInformerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.App.calico.cgColor
        label.layer.cornerRadius = 15
        label.textColor = UIColor.App.calico
        label.text = "Акцій"
        return label
    }()
    
    private lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "credit-card")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var deliveryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "Доставка - від 0$"
        return label
    }()
    
    private lazy var todayWorkingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.App.bilbao
        label.textAlignment = .center
        return label
    }()
    
    private lazy var discountAndDeliveryStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(actionInformerStackView)
        stack.addArrangedSubview(deliveryLabel)
        return stack
    }()
    
    private lazy var actionInformerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.contentMode = .left
        stack.spacing = 10
        stack.addArrangedSubview(discountLabel)
        stack.addArrangedSubview(actionInformerLabel)
        stack.addArrangedSubview(cardImageView)
        return stack
    }()
    
    private lazy var detailStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.addArrangedSubview(restaurantImageView)
        stack.addArrangedSubview(discountAndDeliveryStackView)
        return stack
    }()
    
    private lazy var additionalInformationStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.addArrangedSubview(ratingLabel)
        stack.addArrangedSubview(todayWorkingTimeLabel)
        stack.addArrangedSubview(statusLabel)
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with restaurant: Restaurant) {
        selectionStyle = .none
        
        titleLabel.text = restaurant.name
        
        if let rating = restaurant.rating {
            ratingLabel.text = "\(rating)/5"
        } else {
            ratingLabel.text = "Нет оценки"
        }
        
        if let actionInformerText = restaurant.actionInformerText, !actionInformerText.isEmpty {
            actionInformerLabel.text = "\(actionInformerText.count) Акцій"
        }
        
        switch restaurant.status {
        case 0:
            todayWorkingTimeLabel.text = "Не працюе"
        case 1:
            todayWorkingTimeLabel.text = restaurant.todayWorkingTimeText
        case 2:
            todayWorkingTimeLabel.text = "Тимчасово не працюе"
        default:
            print("unknown restaurant status")
        }
        
        switch restaurant.isWorkingNow {
        case 0:
            statusLabel.text = "предзамовлення"
        case 1:
            statusLabel.text = "відкрито"
        default:
            print("unknown working status")
        }
        
        switch restaurant.onlinePayment {
        case 1:
            cardImageView.alpha = 1
        default:
            cardImageView.alpha = 0
        }
        
        guard let urlToImage = restaurant.image else { return }
        let url = URL(string: urlToImage)
        restaurantImageView.sd_setImage(with: url)
    }
    
    private func configureUI() {
        
        addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.25)
        }
        
        addSubview(detailStackView)
        detailStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleView.snp.bottom)
            $0.height.equalToSuperview().multipliedBy(0.5)
        }
        
        addSubview(additionalInformationStackView)
        additionalInformationStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(detailStackView.snp.bottom)
        }
        
        actionInformerStackView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.5)
        }
        
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(bounds.width * 0.04)
            $0.height.equalToSuperview().multipliedBy(0.5)
        }
        
        restaurantImageView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.4)
        }
        
        actionInformerLabel.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.5)
            $0.width.equalToSuperview().multipliedBy(0.3)
        }
        
        discountLabel.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.5)
            $0.width.equalToSuperview().multipliedBy(0.38)
        }
        
        cardImageView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.5)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(bounds.width * 0.04)
            $0.width.equalToSuperview().multipliedBy(0.36)
        }
        
        todayWorkingTimeLabel.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(4)
        }
    }
}
