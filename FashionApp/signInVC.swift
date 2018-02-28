//
//  signinVC.swift
//  FashionApp
//
//  Created by Dongze Li on 2/17/18.
//  Copyright © 2018 Dongze Li. All rights reserved.
//

import UIKit

class signInVC: UIViewController {
    let networkController = NetworkController()
    var userToken = ""
    // text fields
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    // buttons
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var SignUpBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // clicked sign in button
    @IBAction func signInBtn_click(_ sender: Any) {
        print("Sign in pressed")
        // hide keyboard
        self.view.endEditing(true)
        // if textfields are empty
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            // show alert message
            let alert = UIAlertController(title: "Please", message: "fill in fields", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        let url = "http://127.0.0.1:8080/api-token-auth/"
        let login_info = ["username": usernameTxt.text!, "password": passwordTxt.text!]
        // asynchonous closure
        networkController.login(url, login_info: login_info) {userToken in
            self.userToken = userToken
            if self.userToken.isEmpty {
                // show alert message
                let alert = UIAlertController(title: "Login Failed", message: "Please enter the correct username and password!", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                // jump to home UI
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
