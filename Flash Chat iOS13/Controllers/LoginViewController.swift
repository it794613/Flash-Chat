//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text{
            Auth.auth().signIn(withEmail: email, password: password) { [self] authResult, error in
                if let e = error{
                    makeAlert()
                    print(e)
                } else {
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
    }
    
    
    func makeAlert(){
        let alert = UIAlertController(title: "경고", message: "이메일, 패스워드를 확인해주세요.", preferredStyle: UIAlertController.Style.alert)
        let defaultAlert = UIAlertAction(title: "ok", style: UIAlertAction.Style.default)
        alert.addAction(defaultAlert)
        self.present(alert, animated: false)
    }

    
}
