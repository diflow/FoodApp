//
//  Restaurant.swift
//  FoodApp
//
//  Created by ivan on 27.03.2021.
//

import Foundation

struct Restaurant: Decodable {
    var name: String?
    var status: Int?
    var image: String?
    var todayWorkingTimeText: String?
    var isWorkingNow: Int?
    var actionInformerText: [String]?
    var availableDeliveryTypes: [Int]?
    var onlinePayment: Int?
    var rating: Float?
}
