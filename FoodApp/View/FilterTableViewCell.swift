//
//  FilterTableViewCell.swift
//  FoodApp
//
//  Created by ivan on 02.04.2021.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}
