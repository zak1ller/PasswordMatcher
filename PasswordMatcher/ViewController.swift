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
    $0.tag = ID_PASSWORD
    $0.delegate = self
    $0.isSecureTextEntry = true
    $0.borderStyle = .roundedRect
  }
  
  lazy var passwordConfirmTextField = UITextField().then {
    $0.tag = ID_PASSWORD_CONFIRM
    $0.delegate = self
    $0.isSecureTextEntry = true
    $0.borderStyle = .roundedRect
  }
  
  lazy var validCheckMessageLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.numberOfLines = 0
  }
  
  lazy var loginButton = UIButton(type: .system).then {
    $0.setTitle("로그인", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
  }
  
  private let ID_PASSWORD = 1
  private let ID_PASSWORD_CONFIRM = 2
  
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
      .sink { self.viewModel.passwordConfirm = $0 }
      .store(in: &subscriptions)
    
    viewModel.passwordMatcher
      .sink { isPasswordMatched in
        if isPasswordMatched {
          self.loginButton.backgroundColor = .systemGreen
        } else {
          self.loginButton.backgroundColor = .systemGray
        }
        self.loginButton.isEnabled = isPasswordMatched
      }
      .store(in: &subscriptions)
    
    viewModel.$passwordValidCheck
      .compactMap { $0 }
      .sink { validCheck in
        if validCheck == .success {
          self.validCheckMessageLabel.textColor = .systemGreen
        } else {
          self.validCheckMessageLabel.textColor = .systemRed
        }
        
        switch validCheck {
        case .noData:
          self.validCheckMessageLabel.text = "비밀번호를 입력해주세요."
        case .tooShort:
          self.validCheckMessageLabel.text = "비밀번호가 너무 짧습니다. 최소 8자 이상 입력해주세요."
        case .tooLong:
          self.validCheckMessageLabel.text = "비밀번호가 너무 깁니다. 최대 25자 미만으로 입력해주세요"
        case .success:
          self.validCheckMessageLabel.text = "사용 가능한 비밀번호 입니다."
        }
      }
      .store(in: &subscriptions)
    
    loginButton.publisher(forEvent: .touchUpInside)
      .sink { _ in
        if self.viewModel.finalCheckPassword {
          let alert = UIAlertController(title: "알림", message: "로그인 성공!", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "확인", style: .cancel))
          self.present(alert, animated: true)
        }
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
    stackView.addArrangedSubview(validCheckMessageLabel)
    stackView.addArrangedSubview(loginButton)
  }
  
  private func setConstraint() {
    stackView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(24)
      make.trailing.equalToSuperview().offset(-24)
      make.top.equalTo(view.layoutMarginsGuide.snp.top).offset(40)
    }
    
    loginButton.snp.makeConstraints { make in
      make.height.equalTo(40)
    }
  }
}

// MARK: - TextField
extension ViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField.tag == ID_PASSWORD {
      passwordConfirmTextField.becomeFirstResponder()
    } else {
      loginButton.sendActions(for: .touchUpInside)
    }
    return true
  }
}
