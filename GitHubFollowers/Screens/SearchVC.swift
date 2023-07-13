//
//  SearchVC.swift
//  GitHubFollowers
//
//  Created by Alex on 25.02.2022.
//

import UIKit

class SearchVC: UIViewController {
    
    
    let logoImageView      = UIImageView()
    let usernameTextField  = GFTextField()
    let callToActionButton = GFButton(backgrondColor: .green, title: "Get Followers")
    var logoImageViewTopConstant: NSLayoutConstraint!
    
    var isUsernameEntered: Bool { return usernameTextField.text!.isEmpty }
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureImageView()
        configureTextField()
        configureCallToButton()
        createDismissKeyboardTapGesture()
    }
    
    // MARK: viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = ""
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: отключение клавиатуры при тапе
    
    func createDismissKeyboardTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: переход к FollowerListVC
    
    @objc func pushFollowerListVC(){
        
        guard !isUsernameEntered else {
            presentGFAlertOnMainThread(title: "Empty Username", message: "Please, enter username. We need to look.", buttonTitle: "Ok")
            return
        }
        
        usernameTextField.resignFirstResponder()
        
        let followerListVC      = FollowerListVC(username: usernameTextField.text!)
        followerListVC.username = usernameTextField.text
        followerListVC.title    = usernameTextField.text
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    // MARK: конфигурация ImagwView
    
    func configureImageView(){
        view.addSubview(logoImageView)
        usernameTextField.delegate  = self
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image         = Images.ghLogo
        
        let topContraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        
        logoImageViewTopConstant = logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topContraintConstant)
        logoImageViewTopConstant.isActive = true
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // MARK: конфигурация текстового поля
    
    func configureTextField(){
        view.addSubview(usernameTextField)
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: конфигурация кнопки
    
    func configureCallToButton(){
        view.addSubview(callToActionButton)
        
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
}

// MARK: убрать клавиатуру при нажатии "Go"

extension SearchVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
