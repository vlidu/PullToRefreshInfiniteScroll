//
//  View+Extensions.swift
//  PullToRefreshPOCSwiftUI
//
//  Created by Alexandre VLADOVICH RELJA on 22/03/2022.
//

import SwiftUI

extension View {
    func onRefresh(onValueChanged: @escaping UIScrollView.ValueChangedAction) -> some View {
        self.modifier(OnListRefreshModifier(onValueChanged: onValueChanged))
    }
    
    // To use with async await methods, is excluded from iOS 15 apple made their own
    @available(iOS, obsoleted: 15)
    func refreshable(action: @escaping @Sendable () async -> Void) -> some View {
        self.modifier(RefreshableModifier(action: action))
    }
}
