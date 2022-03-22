//
//  NetworkService.swift
//  PullToRefreshPOCSwiftUI
//
//  Created by Alexandre VLADOVICH RELJA on 22/03/2022.
//

import SwiftUI

class NetworkService {
    func loadData(page: Int,
                  completion: @escaping (Result<ListResponse, RequestError>) -> Void) {
        let url = URL(string: "https://s3.eu-west-2.amazonaws.com/com.donnywals.misc/feed-\(page).json")!

        do {
            let data = try Data(contentsOf: url)
            let listResponse = try JSONDecoder().decode(ListResponse.self, from: data)

            completion(.success(listResponse))
        } catch {
            completion(.failure(.noResponse))
        }
    }
}
