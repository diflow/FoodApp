//
//  NetworkManager.swift
//  FoodApp
//
//  Created by ivan on 27.03.2021.
//

import Foundation
import RxSwift
import RxCocoa

class NetworkManager {
    private enum FetchError: Error {
            case invalidResponse(URLResponse?)
            case invalidJSON(Error)
        }
    
    func fetchRestaurants() -> Observable<[Restaurant]> {
        let url = URL(string: "https://stage0.mister.am/public-api/companies/1")!
        let request = URLRequest(url: url)
        return URLSession.shared.rx.response(request: request)
            .map { result -> Data in
                guard result.response.statusCode == 200 else {
                    throw FetchError.invalidResponse(result.response)
                }
                return result.data
            }.map { data in
                do {
                    let restaurants = try JSONDecoder().decode(
                        [Restaurant].self, from: data
                    )
                    return restaurants
                } catch let error {
                    throw FetchError.invalidJSON(error)
                }
            }
            .observeOn(MainScheduler.instance)
            .asObservable()
    }
    
   func fetchDeliveryData() -> Observable<[Filter]> {
            let url = URL(string: "https://stage0.mister.am/public-api/city/1")!
            let request = URLRequest(url: url)
            return URLSession.shared.rx.response(request: request)
                .map { result -> Data in
                    guard result.response.statusCode == 200 else {
                        throw FetchError.invalidResponse(result.response)
                    }
                    return result.data
                }.map { data in
                    do {
                        let responce = try JSONDecoder().decode(
                            apiResponse.self, from: data
                        )
                        let deliveryData = responce.deliveryData
                        return deliveryData
                    } catch let error {
                        throw FetchError.invalidJSON(error)
                    }
                }
                .observeOn(MainScheduler.instance)
                .asObservable()
       }
}
