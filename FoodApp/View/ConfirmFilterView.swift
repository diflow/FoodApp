//
//  ConfirmFilterView.swift
//  FoodApp
//
//  Created by ivan on 28.03.2021.
//

import UIKit

class ConfirmFilterView: UIView {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "Обрано"
        return label
    }()
    
    private lazy var restaurantsCountlabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.App.bilbao
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Підтвердити", for: .normal)
        button.backgroundColor = UIColor.App.bilbao
        button.layer.cornerRadius = 20
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = UIColor.App.blackSqueeze
        layer.cornerRadius = 20
        
        addSubview(label)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(12)
            $0.height.equalToSuperview().multipliedBy(0.2)
        }
        
        addSubview(restaurantsCountlabel)
        restaurantsCountlabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(label.snp.trailing).inset(-6)
            $0.height.equalToSuperview().multipliedBy(0.2)
        }
        
        addSubview(button)
        button.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
            $0.height.equalToSuperview().multipliedBy(0.5)
            $0.width.equalToSuperview().multipliedBy(0.35)
        }
    }
    
    func setRestaurantsCountlabel(count: Int) {
        restaurantsCountlabel.text = "\(count)" + " закладів"
    }
}
