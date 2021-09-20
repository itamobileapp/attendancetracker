//
//  ViewController.swift
//  test
//
//  Created by Sankar Ramanathan on 6/14/21.
//  Copyright © 2021 Sankar Ramanathan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var txtLogin: UITextField?
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtPassword: UITextField?
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var lblMessage: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        txtLogin?.delegate = self
        txtPassword?.delegate = self
        lblPassword.layer.cornerRadius = 5
        lblPassword.layer.masksToBounds = true
        btnSubmit.layer.cornerRadius = 10
        btnCancel.layer.cornerRadius = 10
        btnOK.layer.cornerRadius = 5
        lblLogin.layer.cornerRadius = 5
        lblLogin.layer.masksToBounds = true
        lblMessage.layer.cornerRadius = 5
        lblMessage?.isHidden = true;
        btnOK?.isHidden = true
        
        txtLogin?.placeholder = "Enter your email address"
        txtPassword?.placeholder = "Enter your password"
        
        txtLogin?.becomeFirstResponder();
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func clickSubmit(_ sender: UIButton) {
        if (txtLogin?.text  == "") {
            lblMessage?.textColor = UIColor.red
            lblMessage?.isHidden = false
            lblMessage?.text = "Please enter the User Name"
        }
        else if (txtPassword?.text == "") {
            lblMessage?.textColor = UIColor.red
            lblMessage?.isHidden = false
            lblMessage?.text = "Please enter the Password"
        }
        else {
            btnOK?.isHidden = true
            lblMessage?.textColor = UIColor.red
            let dict:Dictionary<String?, String?> = ["email": txtLogin?.text, "password": txtPassword?.text]
            let trailingUrl:String = Utils.userLogin
            let request:URLRequest = Utils.createHttpRequest(dict: dict, trailingUrl: trailingUrl, method: "POST")
            Utils.sendPostRequest(request: request, completion: { (data, error) in
                do {
                    let returnVal = Swift.Int(data)!
                    if (returnVal > 0) {
                        self.lblMessage?.isHidden = true
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionViewController
                        self.present(nextViewController, animated:true, completion:nil)                        
                    }
                    else {
                        self.lblMessage?.isHidden = false
                        self.lblMessage.text = "Please verify your credentials."
                    }
                }
            })
        }
    }
    
    @IBAction func clickClear(_ sender: UIButton) {
        lblMessage?.isHidden = true
        btnOK?.isHidden = true
        txtLogin?.text = ""
        txtLogin?.text = ""
        txtPassword?.text = ""
        txtLogin?.becomeFirstResponder();
    }
    
}

struct Result: Codable {
    let userId : String
    let pwd : String
}




