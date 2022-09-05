//
//  ViewModel.swift
//  PasswordMatcher
//
//  Created by Min-Su Kim on 2022/09/03.
//

import Foundation
import Combine

final class ViewModel {
  @Published var password = "" {
    didSet {
      checkValidPassword()
    }
  }
  @Published var passwordConfirm = ""
  @Published var passwordValidCheck: PasswordValidCheck?
  
  var finalCheckPassword: Bool {
    if passwordValidCheck == .success {
      if password == passwordConfirm {
        return true
      }
    }
    return false
  }
  
  var subscriptions = Set<AnyCancellable>()
  
  enum PasswordValidCheck {
    case noData
    case tooShort
    case tooLong
    case success
  }

  var passwordMatcher: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest($password, $passwordConfirm)
      .map { password, passwordConfirm in
        if password.isEmpty || passwordConfirm.isEmpty {
          return false
        }
        return password == passwordConfirm
      }
      .eraseToAnyPublisher()
  }
  
  func checkValidPassword() {
    if password.isEmpty {
      passwordValidCheck = .noData
    } else if password.count < 8 {
      passwordValidCheck = .tooShort
    } else if password.count >= 25 {
      passwordValidCheck = .tooLong
    } else {
      passwordValidCheck = .success
    }
  }
}
