//
//  DeliveryData.swift
//  FoodApp
//
//  Created by ivan on 28.03.2021.
//

import Foundation

struct apiResponse: Decodable {
    var deliveryData: [Filter]
}

struct Filter: Decodable {
    var type: Int
    var title: String
}
