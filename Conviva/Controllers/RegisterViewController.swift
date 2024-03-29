//
//  RegisterViewController.swift
//  Conviva
//
//  Created by Gabriel Ferreira on 21/11/19.
//  Copyright © 2019 Gabriel Ferreira. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var nameProfile: TextFieldView!
    @IBOutlet weak var emailProfile: TextFieldView!
    @IBOutlet weak var addressProfile: TextFieldView!
    @IBOutlet weak var contactProfile: TextFieldView!
    @IBOutlet weak var skillsProfile: TextFieldView!
    @IBOutlet weak var passwordProfile: TextFieldView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var longitude: Double = -25.0
    var latitude: Double = -40.0
    var radius: Double = 10000.0
    
    var address: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Setup.setupViewController(self)
        Setup.setupButton(self.registerButton, withText: "Finalizar")
        Setup.setupDissmiss(self.view)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if let address = self.address {
            self.addressProfile.textField.text = address
        }
        self.nameProfile.textField.placeholder = "Nome Completo"
        self.emailProfile.textField.placeholder = "Email"
        self.emailProfile.textField.keyboardType = .emailAddress
        self.contactProfile.textField.placeholder = "Contato"
        self.contactProfile.textField.keyboardType = .phonePad
        self.skillsProfile.textField.placeholder = "Habilidades"
        self.passwordProfile.textField.placeholder = "Senha"
        
        self.addressProfile.isUserInteractionEnabled = false
        self.addressProfile.textField.placeholder = "Endereço"
    }

    func checkForEmptyTextField() -> Bool {
        var returnValue: Bool = true
          
        //Checando se todos os campos foram completados
        returnValue = textFieldEmpty(self.nameProfile) && returnValue
        returnValue = textFieldEmpty(self.emailProfile) && returnValue
        returnValue = textFieldEmpty(self.addressProfile) && returnValue
        returnValue = textFieldEmpty(self.contactProfile) && returnValue
        returnValue = textFieldEmpty(self.skillsProfile) && returnValue
        returnValue = textFieldEmpty(self.passwordProfile) && returnValue
          
        return returnValue
      }
      
      func textFieldEmpty(_ textfieldView : TextFieldView) -> Bool{
          textfieldView.emptyTextndicator.isHidden = textfieldView.textField.text == "" ? false : true
          return textfieldView.emptyTextndicator.isHidden
      }
      
      
    func makeAPIRequest() {
        if checkForEmptyTextField() {
            let newProfile = Profile(name: self.nameProfile.textField.text!, email: self.emailProfile.textField.text!, password: self.passwordProfile.textField.text!, contact: self.contactProfile.textField.text!, address: self.addressProfile.textField.text!, description: self.skillsProfile.textField.text!, latitude: self.latitude, longitude: self.longitude, radius: self.radius)

            //Chamada do método POST para profile
            let postRequest = APIRequest(endpoint: "profiles")
            postRequest.saveProfile(newProfile, httpMethod: "POST") { result in
                switch result {
                    case .success(let newProfile):
                    DispatchQueue.main.async {
                        print("O perfil foi salvo \(String(describing: newProfile.name))")
                        self.dismiss(animated: true)
                    }
                  case .failure(let error):
                     print("Ocorreu um erro \(error)")
                     //UIALERT
                 }
             }
        }
    }
    
    @IBAction func register(_ sender: Any) {
        if checkForEmptyTextField() {
            makeAPIRequest()
        }
 
    }
    
    //MARK: Methods to manage keybaord
    @objc func keyboardDidShow(notification: NSNotification) {
        let info = notification.userInfo
        let keyBoardSize = info![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyBoardSize.height, right: 0.0)
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyBoardSize.height, right: 0.0)
    }

    @objc func keyboardDidHide(notification: NSNotification) {

        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}
