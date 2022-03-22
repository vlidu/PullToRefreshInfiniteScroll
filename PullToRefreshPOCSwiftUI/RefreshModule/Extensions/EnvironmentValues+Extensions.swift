//
//  EnvironmentValues+Extensions.swift
//  PullToRefreshPOCSwiftUI
//
//  Created by Alexandre VLADOVICH RELJA on 22/03/2022.
//

import SwiftUI

extension EnvironmentValues {
    var refresh: RefreshAction? {
        get { self[RefreshActionKey.self] }
        set { self[RefreshActionKey.self] = newValue }
    }
}
