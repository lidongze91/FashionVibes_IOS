//
//  resetPasswordVC.swift
//  FashionApp
//
//  Created by Dongze Li on 2/17/18.
//  Copyright © 2018 Dongze Li. All rights reserved.
//

import UIKit

class resetPasswordVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    // buttons
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // alignment
        emailTxt.frame = CGRect(x: 10, y: 120, width: self.view.frame.size.width - 20, height: 30)
        
        resetBtn.frame = CGRect(x: 20, y: emailTxt.frame.origin.y + 50, width: self.view.frame.size.width / 4, height: 30)
        resetBtn.layer.cornerRadius = resetBtn.frame.size.width / 20
        
        cancelBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width / 4 - 20, y: resetBtn.frame.origin.y, width: self.view.frame.size.width / 4, height: 30)
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.width / 20
        
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
    }
    
    // click reset button
    @IBAction func resetBtn_click(_ sender: Any) {
        self.view.endEditing(true)
        if emailTxt.text!.isEmpty {
            let alert = UIAlertController(title: "Email Field", message: "is empty!",
                                          preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    // click cancel button
    @IBAction func cancelBtn_click(_ sender: Any) {
        self.dismiss(animated: true, completion:nil)
    }
    
}
