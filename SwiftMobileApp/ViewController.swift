//
//  ViewController.swift
//  test
//
//  Created by Sankar Ramanathan on 6/14/21.
//  Copyright © 2021 Sankar Ramanathan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var txt: String = ""

    @IBOutlet weak var txtLogin: UITextField?
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtPassword: UITextField?
    
    @IBOutlet weak var lblSubmitLogin: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPassword.layer.cornerRadius = 5
        lblPassword.layer.masksToBounds = true
        btnSubmit.layer.cornerRadius = 10
        btnCancel.layer.cornerRadius = 10
        lblLogin.layer.cornerRadius = 5
        lblLogin.layer.masksToBounds = true
<<<<<<< Updated upstream
     //   lblSuccess.layer.cornerRadius = 5
        lblSubmitLogin.layer.cornerRadius = 5
        
        
        //txtLogin.heightAnchor = 40
        // Do any additional setup after loading the view.
    }
=======
        lblMessage.layer.cornerRadius = 5
        lblMessage?.isHidden = true;
        btnOK?.isHidden = true
        txtLogin?.becomeFirstResponder();
    }
    
    
>>>>>>> Stashed changes
    
    @IBAction func clickSubmit(_ sender: UIButton) {
<<<<<<< Updated upstream
        lblSubmitLogin.isHidden = false
  
    }
=======
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
            lblMessage?.isHidden = false
            lblMessage?.textColor = UIColor.systemGreen
            btnOK?.isHidden = false
            let dict:Dictionary<String?, String?> = ["email": txtLogin?.text, "password": txtPassword?.text]
            let trailingUrl:String = Utils.userLogin
            let request:URLRequest = Utils.createHttpPostRequest(dict: dict, trailingUrl: trailingUrl)
            Utils.sendPostRequest(request: request, completion: completion)
        }
    }
    
    let completion: (String, Error?) -> Void = {
        data, error in
            print(data)
            lblMessage?.text = data
    }
    
>>>>>>> Stashed changes
    
    @IBAction func clickClear(_ sender: UIButton) {
        lblSubmitLogin.isHidden = true
        txtLogin?.text = ""
        txtPassword?.text = ""
        
        
        
        
    }
    
}

