//
//  ViewController.swift
//  test
//
//  Created by Sankar Ramanathan on 6/14/21.
//  Copyright © 2021 Sankar Ramanathan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


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
        txtLogin?.becomeFirstResponder();
    }
    
    
    private func parseJSON() {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {
            
            return
        }
        let url = URL(fileURLWithPath: path)
        
        var result: Result?
        do {
            let jsonData = try Data(contentsOf: url)
            result = try JSONDecoder().decode(Result.self, from:jsonData)
            
            if let result = result {
                print(result)
            }
            else {
                print ("Failed to pass")
            }
        }
        catch {
            print ("Error: \(error)")
        }
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
            lblMessage?.isHidden = false
            lblMessage?.text = "Logged In Successfully"
            lblMessage?.textColor = UIColor.systemGreen
            btnOK?.isHidden = false
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




