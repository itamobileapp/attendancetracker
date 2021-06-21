//
//  SelectionController.swift
//  test
//
//  Created by Sankar Ramanathan on 6/14/21.
//  Copyright © 2021 Sankar Ramanathan. All rights reserved.
//

import UIKit

class SelectionController: UIViewController {
    
    private let dataSourceBranch = ["Evergreen","Cupertino","Fremont","Pleasanton"]
    private let dataSourceGrade = ["Grade 1","Grade 2"]
    private let dataSourceSection = ["Section A","Section B"]

    @IBOutlet weak var btnSelectionClear: UIButton!
    @IBOutlet weak var btnSelectionSubmit: UIButton!
    @IBOutlet var lblBranch: UIView!
    @IBOutlet weak var lblGrade: UILabel!
    @IBOutlet weak var lblSection: UILabel!
    @IBOutlet weak var lblTeacher: UILabel!
    @IBOutlet weak var lblSubmitSelection: UILabel!
    @IBOutlet weak var ddlBranch: UIPickerView!
    @IBOutlet weak var ddlGrade: UIPickerView!
    @IBOutlet weak var ddlSection: UIPickerView!
    @IBOutlet weak var lblTeacherName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ddlBranch.dataSource = self
        ddlBranch.delegate = self
        ddlGrade.dataSource = self
        ddlGrade.delegate = self
        ddlSection.dataSource = self
        ddlSection.delegate = self
        btnSelectionClear.layer.cornerRadius = 10
        btnSelectionSubmit.layer.cornerRadius = 10
    }
    @IBAction func clickSubmitSelection(_ sender: UIButton) {
        lblSubmitSelection.isHidden = false
    }
    @IBAction func clickClearSelection(_ sender: UIButton) {
        lblSubmitSelection.isHidden = true
        lblTeacherName.text = "Teacher Name"
    }
    
}

extension SelectionController: UIPickerViewDelegate, UIPickerViewDataSource {

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
            lblTeacherName.text = dataSourceSection[row]
        }
        else if (ddlCommon == ddlBranch) {
            lblTeacherName.text = dataSourceBranch[row]
        }
        else if (ddlCommon == ddlGrade) {
            lblTeacherName.text = dataSourceGrade[row]
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


