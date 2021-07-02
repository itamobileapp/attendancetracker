//
//  SelectionViewController.swift
//  test
//
//  Created by Sankar Ramanathan on 6/14/21.
//  Copyright © 2021 Sankar Ramanathan. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {
    
    private let dataSourceBranch = ["Evergreen","Cupertino","Fremont","Pleasanton"]
    private let dataSourceGrade = ["Grade 1","Grade 2"]
    private let dataSourceSection = ["Section A","Section B"]

    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblBranch: UILabel!
    @IBOutlet weak var lblGrade: UILabel!
    @IBOutlet weak var lblSection: UILabel!

    @IBOutlet weak var lblTeacher: UILabel!
    @IBOutlet weak var lblTeacherName: UILabel!

    @IBOutlet weak var ddlBranch: UIPickerView!
    @IBOutlet weak var ddlGrade: UIPickerView!
    @IBOutlet weak var ddlSection: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        ddlBranch.dataSource = self
        ddlBranch.delegate = self
        ddlGrade.dataSource = self
        ddlGrade.delegate = self
        ddlSection.dataSource = self
        ddlSection.delegate = self
        btnSubmit.layer.cornerRadius = 10
        btnSubmit.layer.cornerRadius = 10
        btnSubmit.layer.cornerRadius = 10
        lblBranch.layer.cornerRadius = 10
        lblGrade.layer.cornerRadius = 10
        lblSection.layer.cornerRadius = 10
        lblTeacher.layer.cornerRadius = 10
        lblTeacherName.layer.cornerRadius = 10
        lblTeacherName.text = ""
        lblMessage.isHidden = true
        
        btnOK.isHidden = true
    }
    
    @IBAction func clickSubmit(_ sender: UIButton) {
        lblMessage.isHidden = false
        btnOK.isHidden = false
    }
    
    @IBAction func clickClear(_ sender: UIButton) {
        lblMessage.isHidden = true
        btnOK.isHidden = true
    }
    
}

extension SelectionViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in ddlCommon: UIPickerView) -> Int {
        if (ddlCommon == ddlSection) {
            return 1
        }
        else if (ddlCommon == ddlBranch) {
            return 1
        }
        else if (ddlCommon == ddlGrade) {
            return 1
        }
        return 1
    }

    func pickerView(_ ddlCommon: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (ddlCommon == ddlSection) {
            return dataSourceSection.count
        }
        else if (ddlCommon == ddlBranch) {
            return dataSourceBranch.count
        }
        else if (ddlCommon == ddlGrade) {
            return dataSourceGrade.count
        }
        return 1
    }

    func pickerView(_ ddlCommon: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (ddlCommon == ddlSection) {
            if dataSourceSection[row] == "Section A" {
                lblTeacherName.text = "Ponmathi Rajendran"
            }
            else if dataSourceSection[row] == "Section B" {
                lblTeacherName.text = "Subhashini Kannan"
            }
        }
        else if (ddlCommon == ddlBranch) {
            lblTeacherName.text = ""
        }
        else if (ddlCommon == ddlGrade) {
            lblTeacherName.text = ""
        }

    }

    func pickerView(_ ddlCommon: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (ddlCommon == ddlSection) {
            return dataSourceSection[row]
        }
        else if (ddlCommon == ddlBranch) {
            return dataSourceBranch[row]
        }
        else if (ddlCommon == ddlGrade) {
            return dataSourceGrade[row]
        }
        return ""
    }
}


