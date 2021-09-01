//
//  SelectionViewController.swift
//  test
//
//  Created by Sankar Ramanathan on 6/14/21.
//  Copyright © 2021 Sankar Ramanathan. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {
    
    
    private var dataSourceBranch : [String] = ["Evergreen","Cupertino","Fremont","Pleasanton"]
    private var dataSourceGrade : [String] = ["Grade 1","Grade 2"]
    private var dataSourceSection : [String] = ["Section A","Section B"]
    
    private var dataSourceDate : [String] = []

    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblBranch: UILabel!
    @IBOutlet weak var lblGrade: UILabel!
    @IBOutlet weak var lblSection: UILabel!

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTeacher: UILabel!
    @IBOutlet weak var lblTeacherName: UILabel!

    @IBOutlet weak var ddlBranch: UIPickerView!
    @IBOutlet weak var ddlGrade: UIPickerView!
    @IBOutlet weak var ddlSection: UIPickerView!
    
    @IBOutlet weak var ddlDate: UIPickerView!
    var branch = ""
    var grade = ""
    var section = ""
    var date = ""

    override func viewDidLoad() {
        
        let cal = Calendar.current

        let stopDate = cal.date(byAdding: .year, value: -1, to: Date())!

        // We want to find dates that match on Sundays at midnight local time
        var comps = DateComponents()
        comps.weekday = 1 // Sunday

        // Enumerate all of the dates
        cal.enumerateDates(startingAfter: Date(), matching: comps, matchingPolicy: .previousTimePreservingSmallerComponents, repeatedTimePolicy: .first, direction: .backward) { (date, match, stop) in
            if let date = date {
                if date < stopDate {
                    stop = true // We've reached the end, exit the loop
                } else {
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                    
                    let dateFormatterPrint = DateFormatter()
                    dateFormatterPrint.dateFormat = "MMM dd, yyyy"
                    
                    if let new_date = dateFormatterGet.date(from: "\(date)") {
                        dataSourceDate.append(dateFormatterPrint.string(from: new_date))
                    } else {
                       print("There was an error decoding the string")
                    }
                }
            }
        }
        
        

        
        
        super.viewDidLoad()
        ddlBranch.dataSource = self
        ddlBranch.delegate = self
        ddlGrade.dataSource = self
        ddlGrade.delegate = self
        ddlSection.dataSource = self
        ddlSection.delegate = self
        ddlDate.dataSource = self
        ddlDate.delegate = self
        
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
        
        lblDate.layer.cornerRadius = 10
        lblDate.layer.masksToBounds = true
        
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
        else if (ddlCommon == ddlDate) {
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
        else if (ddlCommon == ddlDate) {
            return dataSourceDate.count
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
        else if (ddlCommon == ddlDate) {
            date = dataSourceDate[row]
            
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
        else if (ddlCommon == ddlDate) {
            date = dataSourceDate[row]
            return dataSourceDate[row]
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


