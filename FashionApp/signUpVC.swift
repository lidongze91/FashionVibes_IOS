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
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        //scrollView frame size
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width,
                                  height: self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height
        // check notification if keyboard is shown or not
        NotificationCenter.default.addObserver(self, selector: #selector(signUpVC.showKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(signUpVC.hideKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        
        // alignment
        avaImg.frame = CGRect(x: self.view.frame.size.width / 2 - 40, y: 50, width: 80, height: 80)
        usernameTxt.frame = CGRect(x: 10, y: avaImg.frame.origin.y + 90, width: self.view.frame.size.width - 20, height: 30)
        passwordTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        repeatPassword.frame = CGRect(x: 10, y: passwordTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        emailTxt.frame = CGRect(x: 10, y: repeatPassword.frame.origin.y + 60, width: self.view.frame.size.width - 20, height: 30)
        webTxt.frame = CGRect(x: 10, y: emailTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        fullnameTxt.frame = CGRect(x: 10, y: webTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        bioTxt.frame = CGRect(x: 10, y: fullnameTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)

        signUpBtn.frame = CGRect(x: 20, y: bioTxt.frame.origin.y + 50, width: self.view.frame.size.width / 4, height: 30)
        signUpBtn.layer.cornerRadius = signUpBtn.frame.size.width / 20

        cancelBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width / 4 - 20, y: signUpBtn.frame.origin.y, width: self.view.frame.size.width / 4, height: 30)
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.width / 20
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
    @objc func showKeyboard(notification: NSNotification) {
        print("keyboard is showing")
        // define keyboard size
        keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)
        // move up UI
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.frame.size.height -= self.keyboard.height
            })
    }
    @objc func hideKeyboard(notification: NSNotification) {
        // move down UI
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
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
        // hide keyboard
        self.view.endEditing(true)
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
