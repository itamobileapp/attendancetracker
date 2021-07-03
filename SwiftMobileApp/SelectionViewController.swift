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
    
    var branch = ""
    var grade = ""
    var section = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        ddlBranch.dataSource = self
        ddlBranch.delegate = self
        ddlGrade.dataSource = self
        ddlGrade.delegate = self
        ddlSection.dataSource = self
        ddlSection.delegate = self
        btnSubmit.layer.cornerRadius = 10
        btnSubmit.layer.masksToBounds = true
        btnClear.layer.cornerRadius = 10
        btnClear.layer.masksToBounds = true
        lblBranch.layer.cornerRadius = 10
        lblBranch.layer.masksToBounds = true
        lblGrade.layer.cornerRadius = 10
        lblGrade.layer.masksToBounds = true
        lblSection.layer.cornerRadius = 10
        lblSection.layer.masksToBounds = true
        lblTeacher.layer.cornerRadius = 10
        lblTeacher.layer.masksToBounds = true
        lblTeacherName.layer.cornerRadius = 10
        lblTeacherName.layer.masksToBounds = true
        lblTeacherName.text = ""
        lblMessage.isHidden = true
        btnOK.isHidden = true
        lblMessage.textColor = UIColor.systemGreen

        ddlBranch?.becomeFirstResponder();

    }
    
    @IBAction func clickSubmit(_ sender: UIButton) {
        lblMessage.isHidden = false
        btnOK.isHidden = false
    }
    
    @IBAction func clickClear(_ sender: UIButton) {
        ddlBranch.selectRow (0, inComponent:0, animated:true)
        ddlGrade.selectRow (0, inComponent:0, animated:true)
        ddlSection.selectRow (0, inComponent:0, animated:true)
        lblTeacherName.text = ""

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
            section = dataSourceSection[row]
            updateTeacherName()
        }
        else if (ddlCommon == ddlBranch) {
            ddlGrade.selectRow (0, inComponent:0, animated:true)
            ddlSection.selectRow (0, inComponent:0, animated:true)
            grade = dataSourceGrade[0]
            section = dataSourceSection[0]
            branch = dataSourceBranch[row]
            updateTeacherName()
        }
        else if (ddlCommon == ddlGrade) {
            ddlSection.selectRow (0, inComponent:0, animated:true)
            section = dataSourceSection[0]
            grade = dataSourceGrade[row]
            updateTeacherName()
        }

    }

    func pickerView(_ ddlCommon: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (ddlCommon == ddlSection) {
            section = dataSourceSection[row]
            return dataSourceSection[row]
        }
        else if (ddlCommon == ddlBranch) {
            branch = dataSourceBranch[row]
            return dataSourceBranch[row]
        }
        else if (ddlCommon == ddlGrade) {
            grade = dataSourceGrade[row]
            return dataSourceGrade[row]
        }
        return ""
    }
    
    func updateTeacherName() {
        if (branch == "Evergreen" && grade == "Grade 2" &&  section == "Section A") {
            lblTeacherName.text = "Ponmathi Rajendran"
        }
        else if (branch == "Evergreen" && grade == "Grade 2" &&  section == "Section B") {
            lblTeacherName.text = "Subhashini Kannan"
        }
        else {
            lblTeacherName.text = ""
        }
    }
}


