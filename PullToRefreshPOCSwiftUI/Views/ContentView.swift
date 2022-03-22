//
//  ContentView.swift
//  PullToRefreshPOCSwiftUI
//
//  Created by Alexandre VLADOVICH RELJA on 21/03/2022.
//

import SwiftUI
import Combine
import Introspect

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
        .refreshable {
            await viewModel.refreshContent()
        }
        .onAppear {
            print("[LIST]: - Appeared")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
