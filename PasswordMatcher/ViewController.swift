//
//  ViewController.swift
//  PasswordMatcher
//
//  Created by Min-Su Kim on 2022/09/03.
//

import UIKit
import Combine

class ViewController: UIViewController {

  lazy var stackView = UIStackView().then {
    $0.axis = .vertical
    $0.distribution = .fill
    $0.spacing = 24
  }
  
  lazy var passwordTextField = UITextField().then {
    $0.isSecureTextEntry = true
    $0.borderStyle = .roundedRect
  }
  
  lazy var passwordConfirmTextField = UITextField().then {
    $0.isSecureTextEntry = true
    $0.borderStyle = .roundedRect
  }
  
  lazy var passwordMatchedMessageLabel = UILabel()
  
  var viewModel: ViewModel!
  var subscriptions = Set<AnyCancellable>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = ViewModel()
    setView()
    setConstraint()
    bind()
  }
  
  private func bind() {
    passwordTextField.textChanged
      .sink {
        self.viewModel.password = $0
      }
      .store(in: &subscriptions)
    
    passwordConfirmTextField.textChanged
      .sink {
        self.viewModel.passwordConfirm = $0
      }
      .store(in: &subscriptions)
    
    viewModel.passwordMatcher
      .sink { isPasswordMatched in
        self.passwordMatchedMessageLabel.text = isPasswordMatched ? "Matched password!" : "No match passwords."
      }
      .store(in: &subscriptions)
  }
}

// MARK: - UI
extension ViewController {
  private func setView() {
    view.addSubview(stackView)
    
    stackView.addArrangedSubview(passwordTextField)
    stackView.addArrangedSubview(passwordConfirmTextField)
    stackView.addArrangedSubview(passwordMatchedMessageLabel)
  }
  
  private func setConstraint() {
    stackView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(24)
      make.trailing.equalToSuperview().offset(-24)
      make.top.equalTo(view.layoutMarginsGuide.snp.top).offset(40)
    }
  }
}
