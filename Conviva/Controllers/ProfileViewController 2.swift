//
//  ProfileViewController.swift
//  Conviva
//
//  Created by Gabriel Ferreira on 27/11/19.
//  Copyright © 2019 Gabriel Ferreira. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var nameProfile: TextFieldView!
    @IBOutlet weak var emailProfile: TextFieldView!
    @IBOutlet weak var addressProfile: TextFieldView!
    @IBOutlet weak var contactProfile: TextFieldView!
    @IBOutlet weak var skillsProfile: TextFieldView!
    @IBOutlet weak var saveButton: UIButton!
    
    var loggedUser: Profile?
    var addressEditedProfile: Profile? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Setup.setupViewController(self)
        Setup.setupButton(self.saveButton, withText: "Salvar")
        
        self.nameProfile.textField.placeholder = "Nome"
        self.emailProfile.textField.placeholder = "Email"
        self.addressProfile.textField.placeholder = "Endereço"
        self.contactProfile.textField.placeholder = "Contato"
        self.skillsProfile.textField.placeholder = "Habilidades"
        
        self.addressProfile.isUserInteractionEnabled = false
        makeAPIRequest()
    }
    
    func makeAPIRequest() {
        let id = UserDefaults.standard.integer(forKey: "ID")
        let getRequest = APIRequest(endpoint: "profiles/id?id=\(id)")
        getRequest.getProfileResponse() { result in
            switch result {
            case .success(let profileData):
                print("Lista de eventos: \(String(describing: profileData))")
                //Dispatch the call to update the label text to the main thread.
                //Reload must only be called on the main thread
                DispatchQueue.main.async{
                    self.nameProfile.textField.text = profileData.name
                    self.emailProfile.textField.text = profileData.email
                    self.addressProfile.textField.text = profileData.address
                    self.contactProfile.textField.text = profileData.contact
                    self.skillsProfile.textField.text = profileData.description
                    
                    self.loggedUser = profileData

                }
            case .failure(let error):
                print("Ocorreu um erro \(error)")
            }
        }
    }
  

    @IBAction func saveEdit(_ sender: Any) {
        if self.loggedUser != nil && checkForChanges() {
            
            let newProfile = Profile(name: self.nameProfile.textField.text!, email: self.emailProfile.textField.text!, password: self.loggedUser!.password!, contact: self.contactProfile.textField.text!, address: self.addressProfile.textField.text!, description: self.skillsProfile.textField.text!, latitude: self.loggedUser!.latitude!, longitude: self.loggedUser!.longitude!, radius: self.loggedUser!.radius!)
            
            if self.addressEditedProfile != nil {
                newProfile.address = self.addressEditedProfile?.address
                newProfile.longitude = self.addressEditedProfile?.longitude
                newProfile.latitude = self.addressEditedProfile?.latitude
                newProfile.radius = self.addressEditedProfile?.radius
            }

            //Chamada do método POST para profile
            if let id = self.loggedUser?.id {
                let postRequest = APIRequest(endpoint: "profiles/\(id)")
                postRequest.saveProfile(newProfile, httpMethod: "PUT") { result in
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
    }
    
    func checkForChanges() -> Bool {
        var changed = false

        if self.loggedUser != nil {
            changed = self.loggedUser!.name == self.nameProfile.textField.text ?  false : true
            changed = (self.loggedUser!.email == self.emailProfile.textField.text ?  false : true) || changed
            changed = (self.loggedUser!.address == self.addressProfile.textField.text ?  false : true) || changed
            changed = (self.loggedUser!.contact == self.contactProfile.textField.text ?  false : true) || changed
            changed = (self.loggedUser!.description == self.skillsProfile.textField.text ?  false : true) || changed
        }
        
        return changed
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfileToMap" {
            let destination = segue.destination as! MapViewController
            destination.isCalledIn = .editProfile
            destination.latitude = loggedUser!.latitude!
            destination.longitude = loggedUser!.longitude!
        }
    }
    
    //Limpar UserDefaults quando deslogar
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set("", forKey: "Email")
        UserDefaults.standard.set("", forKey: "ID")
    }
}
