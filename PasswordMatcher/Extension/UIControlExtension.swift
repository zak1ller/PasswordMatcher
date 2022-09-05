//
//  UIControlExtension.swift
//  PasswordMatcher
//
//  Created by Min-Su Kim on 2022/09/05.
//

import Foundation
import Combine
import UIKit

extension UIControl {
  func publisher(forEvent event: Event = .primaryActionTriggered) -> Publishers.Control {
    .init(control: self, event: event)
  }
}
