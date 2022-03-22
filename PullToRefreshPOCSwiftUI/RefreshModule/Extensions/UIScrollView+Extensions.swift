//
//  UIScrollView+Extensions.swift
//  PullToRefreshPOCSwiftUI
//
//  Created by Alexandre VLADOVICH RELJA on 22/03/2022.
//

import SwiftUI

extension UIScrollView {
    private struct Keys {
        static var onValueChanged: UInt8 = 0
    }
    
    typealias ValueChangedAction = ((_ refreshControl: UIRefreshControl) -> Void)
    
    private var onValueChanged: ValueChangedAction? {
        get {
            objc_getAssociatedObject(self, &Keys.onValueChanged) as? ValueChangedAction
        }
        set {
            objc_setAssociatedObject(self, &Keys.onValueChanged, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func onRefresh(_ onValueChanged: @escaping ValueChangedAction) {
        if refreshControl == nil {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(
                   self,
                   action: #selector(self.onValueChangedAction),
                   for: .valueChanged
               )
            self.refreshControl = refreshControl
        }
        self.onValueChanged = onValueChanged
    }
    
    @objc private func onValueChangedAction(sender: UIRefreshControl) {
        self.onValueChanged?(sender)
    }
}
