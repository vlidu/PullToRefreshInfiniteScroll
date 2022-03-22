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
    
    private var service = NetworkService()
    
    var currentPage = 1
    
    private var canLoadMorePages = true
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadItems()
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
    
    func loadItems() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        
        service.loadData(page: currentPage) { result in
            self.handleResult(result)
        }
    }
}

// MARK: - Data

extension ContentViewModel {
    func loadMoreContentIfNeeded(currentItem item: ListItem?) {
        guard let item = item else {
            loadItems()

            return
        }
        
        let thresholdIndex = items.index(items.endIndex, offsetBy: -1)
        
        if items.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadItems()
        }
    }
    
    func refreshContent() async {
        reset()
                
        let asyncData = await withCheckedContinuation { continuation in
            service.loadData(page: currentPage) { result in
                continuation.resume(returning: result)
            }
        }
            
        self.handleResult(asyncData)
    }
}
