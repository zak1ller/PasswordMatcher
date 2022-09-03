//
//  ViewModel.swift
//  PasswordMatcher
//
//  Created by Min-Su Kim on 2022/09/03.
//

import Foundation
import Combine

final class ViewModel {
  @Published var password = ""
  @Published var passwordConfirm = ""
  
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
}
