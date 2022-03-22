//
//  ContentViewModel.swift
//  PullToRefreshPOCSwiftUI
//
//  Created by Alexandre VLADOVICH RELJA on 22/03/2022.
//

import SwiftUI
import Combine

// MainActor is mandatory otherwise we get a [Publishing changes from background threads...] warning on runtime.
@MainActor class ContentViewModel: ObservableObject {
    @Published var isLoadingPage: Bool = false
    @Published var items: [ListItem] = []
    
    var currentPage = 1
    
    private var canLoadMorePages = true
    private var cancellables = Set<AnyCancellable>()
    private var url: URL {
        URL(string: "https://s3.eu-west-2.amazonaws.com/com.donnywals.misc/feed-\(currentPage).json")!
    }
    
    init() {
        loadData { self.handleResult($0) }
    }
    
    private func reset() {
        items = []
        currentPage = 1
        canLoadMorePages = true
    }
    
    private func handleResult(_ result: Result<ListResponse, RequestError>) {
        switch result {
        case .success(let response):
            self.canLoadMorePages = response.hasMorePages
            self.isLoadingPage = false
            self.currentPage += 1
            self.items = self.items + response.items
        case .failure(let error):
            print(error)
        }
    }

    func refreshContent() async {
        print("Start loading data")
        
        reset()
                
        let asyncData = await withCheckedContinuation { continuation in
            loadData { result in
                continuation.resume(returning: result)
            }
        }
            
        self.handleResult(asyncData)
        
        print("Data loaded")
    }
}

// MARK: - Data

extension ContentViewModel {
    func loadData(completion: @escaping (Result<ListResponse, RequestError>) -> Void) {
        guard !isLoadingPage && canLoadMorePages else {
            completion(.failure(.unauthorized))
            return
        }
        
        isLoadingPage = true
        
        do {
            let data = try Data(contentsOf: url)
            let listResponse = try JSONDecoder().decode(ListResponse.self, from: data)

            completion(.success(listResponse))
        } catch {
            completion(.failure(.noResponse))
        }
    }
    
    func loadMoreContentIfNeeded(currentItem item: ListItem?) {
        guard let item = item else {
            loadData { self.handleResult($0) }

            return
        }
        
        let thresholdIndex = items.index(items.endIndex, offsetBy: -1)
        
        if items.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadData { self.handleResult($0) }
        }
    }
}
