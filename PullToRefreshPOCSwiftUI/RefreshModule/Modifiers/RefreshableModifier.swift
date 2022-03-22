//
//  RefreshableModifier.swift
//  PullToRefreshPOCSwiftUI
//
//  Created by Alexandre VLADOVICH RELJA on 22/03/2022.
//

import SwiftUI

struct RefreshableModifier: ViewModifier {
    let action: () async -> Void
    
    func body(content: Content) -> some View {
        content
            .environment(\.refresh, RefreshAction(action: action))
            .onRefresh { refreshControl in
                Task {
                    await action()
                    refreshControl.endRefreshing()
                }
            }
    }
}
