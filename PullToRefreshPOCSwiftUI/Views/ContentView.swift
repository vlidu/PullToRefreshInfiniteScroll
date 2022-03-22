//
//  ContentView.swift
//  PullToRefreshPOCSwiftUI
//
//  Created by Alexandre VLADOVICH RELJA on 21/03/2022.
//

import SwiftUI
import Combine
import RefreshableScrollView

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()

    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                Text(item.label)
                    .onAppear {
                        viewModel.loadMoreContentIfNeeded(currentItem: item)
                    }
                    .padding(.all, 30)
            }
        }
        .onRefresh {
            await viewModel.refreshContent()
        }
        .onAppear {
            viewModel.loadItems()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
