//
//  RefreshAction.swift
//  PullToRefreshPOCSwiftUI
//
//  Created by Alexandre VLADOVICH RELJA on 22/03/2022.
//

import SwiftUI

public struct RefreshAction {
    let action: () async -> Void
    
    public func callAsFunction() async {
        await action()
    }
}
