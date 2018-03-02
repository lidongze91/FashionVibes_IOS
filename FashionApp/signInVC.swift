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
    static var userToken = ""
    // text fields
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    // buttons
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // check how many fonts are there
//        for family: String in UIFont.familyNames
//        {
//            print("\(family)")
//            for names: String in UIFont.fontNames(forFamilyName: family)
//            {
//                print("== \(names)")
//            }
//        }
        label.font = UIFont(name: "Pacifico", size: 35)
        // assignment
        label.frame = CGRect(x: 10, y: 80, width: self.view.frame.size.width-20, height: 50)
        usernameTxt.frame = CGRect(x: 10, y: label.frame.origin.y+100,
                                   width: self.view.frame.size.width-20, height: 30)
        passwordTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y+40,
                                   width: self.view.frame.size.width-20, height: 30)
        forgotBtn.frame = CGRect(x: 20, y: passwordTxt.frame.origin.y+30,
                                 width: self.view.frame.size.width-20, height: 30)
        signInBtn.frame = CGRect(x: 20, y: forgotBtn.frame.origin.y+70,
                                 width: self.view.frame.size.width/4, height: 30)
        signInBtn.layer.cornerRadius = signInBtn.frame.size.width / 20
        signUpBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width/4-20, y: signInBtn.frame.origin.y, width: self.view.frame.size.width/4, height: 30)
        signUpBtn.layer.cornerRadius = signUpBtn.frame.size.width / 20

        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(signInVC.hideKeyboardTap(recognizer:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
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
            signInVC.userToken = userToken
            if signInVC.userToken.isEmpty {
                // show alert message
                let alert = UIAlertController(title: "Login Failed", message: "Please enter the correct username and password!", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                // jump to home UI
                //self.performSegue(withIdentifier: "HomeVC", sender: nil)
                // remember user or save in App Memeory did the user login or not
                UserDefaults.standard.set(signInVC.userToken, forKey: "Token")
                UserDefaults.standard.synchronize()
                
                // call login function from AppDelegate.swift class
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
            }
        }
    }
    @objc func hideKeyboardTap(recognizer : UITapGestureRecognizer) {
        self.view.endEditing(true)
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
