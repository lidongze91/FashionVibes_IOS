//
//  signupVC.swift
//  FashionApp
//
//  Created by Dongze Li on 2/17/18.
//  Copyright © 2018 Dongze Li. All rights reserved.
//

import UIKit

class signUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // profile image
    @IBOutlet weak var avaImg: UIImageView!
    // textfields
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    // scrollView
    @IBOutlet weak var scrollView: UIScrollView!
    // reset the default size
    var scrollViewHeight:CGFloat = 0
    // keyboard frame size
    var keyboard = CGRect()
    let networkController = NetworkController()
    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        //scrollView frame size
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width,
                                  height: self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height
        // check notification if keyboard is shown or not
        NSNotification.addObserver(self, forKeyPath: "showKeyboard:", context:nil)
        NSNotification.addObserver(self, forKeyPath: "hideKeyboard:", context:nil)
        // declare hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(signUpVC.hideKeyboardTap(recognizer:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // round the image configuration
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2;
        avaImg.clipsToBounds = true
        // declare select image tap
        let avaTap = UITapGestureRecognizer(target: self, action:
            #selector(loadImg(recognizer:)))
        avaTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(avaTap)
        // Do any additional setup after loading the view.
    }
    // call picker to select image
    @objc func loadImg(recognizer: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    // connect selected image to our imageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    // hide keyboard if tapped
    @objc func hideKeyboardTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    // show keyboard
    func showKeyboard(notification: NSNotification) {
        print("keyboard is showing")
        // define keyboard size
        keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)
        // move up UI
        UIView.animate(withDuration: 0.4, animations: {
            self.scrollView.frame.size.height -= self.keyboard.height
            })
    }
    func hideKeyboard(notification: NSNotification) {
        // move down UI
        UIView.animate(withDuration: 0.4, animations: {
            self.scrollView.frame.size.height = self.view.frame.height
        })
    }
    // clicked sign up
    @IBAction func signUpBtn_click(_ sender: Any) {
        print("sign up pressed")
        // dismiss keyboard
        self.view.endEditing(true)
        // information validation that fields are empty
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty ||
            repeatPassword.text!.isEmpty || emailTxt.text!.isEmpty ||
            fullnameTxt.text!.isEmpty || bioTxt.text!.isEmpty || webTxt.text!.isEmpty {
            // alert message
            let alert = UIAlertController(title: "PLEASE", message: "fill all fields",
                                          preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        // if different password
        if passwordTxt.text != repeatPassword.text {
            // alert message
            let alert = UIAlertController(title: "PASSWORDS", message: "do not match",
                                          preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        // save the user information to the server after signing up
        let user_info = ["email": emailTxt.text!, "name": usernameTxt.text!,
                         "password": passwordTxt.text!, "bio": bioTxt.text!,
                         "web": webTxt.text!, "full_name": fullnameTxt.text!]
        let url = "http://127.0.0.1:8080/profiles/userinfo/"
        networkController.data_request(url, user_info: user_info)
    }
    // clicked cancel
    @IBAction func cancelBtn_click(_ sender: Any) {
        print("cancel pressed")
        self.dismiss(animated: true, completion: nil)
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
