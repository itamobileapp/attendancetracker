//
//  SelectionViewController.swift
//  test
//
//  Created by Sankar Ramanathan on 6/14/21.
//  Copyright © 2021 Sankar Ramanathan. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {
    
    @IBOutlet weak var txtBranch: UITextField!
    @IBOutlet weak var txtGrade: UITextField!
    @IBOutlet weak var txtSection: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblBranch: UILabel!
    @IBOutlet weak var lblGrade: UILabel!
    @IBOutlet weak var lblSection: UILabel!

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTeacher: UILabel!
    @IBOutlet weak var lblTeacherName: UILabel!

    var branch = [""]
    var branchName = [""]
    var branchCount = 0

    var grade = [""]
    var gradeName = [""]
    var gradeCount = 0

    var sectionName = [""]
    var sectionId = [""]
    var sectionCount = 0
    var selectedSectionId = "-1"
    
    var teacherName = [""]
    
    var date = ""
    var dateCount : [String] = [String]()


    var section_dict:Dictionary<String?,[String]?>? = nil
    
    var branchPickerView = UIPickerView()
    var gradePickerView = UIPickerView()
    var sectionPickerView = UIPickerView()
    var datePickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict_branch:Dictionary<String?, String?>? = nil
        getData(dict: dict_branch, trailingUrl:Utils.branchInfo, tag: 1) {() -> Void in
            self.branchPickerView.delegate = self
            self.branchPickerView.dataSource = self
            self.branchPickerView.tag = 1
            
            self.sectionPickerView.delegate = self
            self.sectionPickerView.dataSource = self
            self.sectionPickerView.tag = 3

            self.gradePickerView.delegate = self
            self.gradePickerView.dataSource = self
            self.gradePickerView.tag = 2

            self.datePickerView.delegate = self
            self.datePickerView.dataSource = self
            self.datePickerView.tag = 4
            
            self.branchPickerView.reloadAllComponents()
        }

        
        txtBranch.inputView = branchPickerView
        txtBranch.placeholder = "Select Branch"
        txtBranch.textAlignment = .center
        
        
        txtGrade.inputView = gradePickerView
        txtGrade.textAlignment = .center
        
        
        txtSection.inputView = sectionPickerView
        txtSection.textAlignment = .center
        
        
        txtDate.inputView = datePickerView
        txtDate.textAlignment = .center
        
        lblTeacherName.text = ""
        lblTeacherName.textAlignment = .center
        lblTeacherName.font = UIFont.boldSystemFont(ofSize: 18)
        
        lblMessage.textAlignment = .center
        lblMessage.text = ""

        
        
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
     
        formatCalendar()
        
    }
    
    @IBAction func clickSubmit(_ sender: UIButton) {
        
        if (txtBranch.text == "" || txtGrade.text == "" || txtSection.text == "" || txtDate.text == "") {
            lblMessage.text = "Please Select All Values"
        }
        else {
            lblMessage.text = ""
            let storyBoard : UIStoryboard = UIStoryboard(name: "Selection", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TrackerVC") as! TrackerViewController
            nextViewController.sectionId = self.selectedSectionId
            nextViewController.attendanceDate = self.txtDate.text!
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    @IBAction func clickClear(_ sender: UIButton) {
        txtBranch.text = ""
        txtGrade.text = ""
        txtSection.text = ""
        lblTeacherName.text = ""
        lblMessage.text = ""
    }
}
    
extension SelectionViewController:UIPickerViewDataSource, UIPickerViewDelegate {
        
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        lblMessage.text = ""
        switch pickerView.tag {
        case 1:
            return self.branchCount
        case 2:
            return self.gradeCount
        case 3:
            return self.sectionCount
        case 4:
            return self.dateCount.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        lblMessage.text = ""
        switch pickerView.tag {
        case 1:
            txtGrade.text = ""
            txtSection.text = ""
            lblTeacherName.text = ""
            return self.branchName[row]
        case 2:
            txtSection.text = ""
            lblTeacherName.text = ""
            return self.gradeName[row]
        case 3:
            lblTeacherName.text = ""
            return self.sectionName[row]
        case 4:
            return dateCount[row]
        default:
            return "Data Not Found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        lblMessage.text = ""
        switch pickerView.tag {
        case 1:
            txtBranch.text = self.branchName[row]
            txtBranch.resignFirstResponder()
            let branchId = Utils.getId(matchingName: txtBranch.text!, arr: branch)
            let dict_grade:Dictionary<String?, String?> = ["branchid": branchId]
            //print(branchId)
            getData(dict: dict_grade, trailingUrl:Utils.gradeInfo, tag: 2) {() -> Void in
            }
        case 2:
            txtGrade.text = self.gradeName[row]
            txtGrade.resignFirstResponder()
            let gradeId = Utils.getId(matchingName: txtGrade.text!, arr: grade)
            let dict_grade:Dictionary<String?, String?> = ["gradeid": gradeId]
            //print(gradeId)
            getData(dict: dict_grade, trailingUrl:Utils.sectionInfo, tag: 3) {() -> Void in
            }
            return
        case 3:
            txtSection.text = self.sectionName[row]
            lblTeacherName.text = self.teacherName[row]
            self.selectedSectionId = getSectionIdForTeacher(idName: lblTeacherName.text!, dict: section_dict)
            txtSection.resignFirstResponder()
            return
        case 4:
            txtDate.text = dateCount[row]
            txtDate.resignFirstResponder()
        default:
            return
        }
    }
    
    func getData(dict:Dictionary<String?, String?>?, trailingUrl: String, tag: Int, completed: @escaping () -> Void) {
        var arr = [String]()
        var arrName = [String]()
        switch(tag) {
        case 1:
            self.branch = [""]
            self.branchName = [""]
            self.branchCount = 0
            let request:URLRequest = Utils.createHttpRequest(dict: dict, trailingUrl: trailingUrl, method: "GET")
            Utils.sendGetRequestSingle(request: request, completion: { (data, error) in
                do {
                    for (key, value) in data {
                        arr.append("\(key):\(value)")
                        arrName.append("\(value)")
                    }
                    arr.sort()
                    arrName.sort()
                    self.branch = arr
                    self.branchName = arrName
                }
                self.branchCount = self.branch.count
                completed()
                //print ("completed the routine - branch")
            })
        case 2:
            self.grade = [""]
            self.gradeName = [""]
            self.gradeCount = 0
            let request:URLRequest = Utils.createHttpRequest(dict: dict, trailingUrl: trailingUrl, method: "GET")
            Utils.sendGetRequestSingle(request: request, completion: { (data, error) in
                do {
                    for (key, value) in data {
                        arr.append("\(key):\(value)")
                        arrName.append("\(value)")
                    }
                    arr.sort()
                    arrName.sort()
                    self.grade = arr
                    self.gradeName = arrName
                }
                self.gradeCount = self.grade.count
                //print(self.grade)
                completed()
                //print ("completed the routine - grade")
            })
        case 3:
            self.section_dict = [:]
            self.sectionName = [""]
            self.sectionCount = 0

            let request:URLRequest = Utils.createHttpRequest(dict: dict, trailingUrl: trailingUrl, method: "GET")
            var dict_val:Dictionary<String,[String]>! = [:]
            Utils.sendGetRequestMultiple(request: request, completion: { (data, error) in
                do {
                    var arrSection_val = [String]()
                    var arrTeacher_val = [String]()
                    var arrSectionId_val = [String()]
                    for (key, value) in data {
                        dict_val[key] = value
                        //print("Both")
                        //print(key)
                        //print(value)

                        //var arrBoth_val = [String]()
                        var i:Int = 0
                        for val in value {
                            if (i % 2 == 0) {
                                arrSection_val.append("\(val)")
                            }
                            else {
                                arrTeacher_val.append("\(val)")
                            }
                            i += 1
                            //arrBoth_val.append(val)
                        }
                        arrSectionId_val.append(key)
                    }
                    arr.sort()
                    arrSectionId_val.sort()
                    arrSection_val.sort()
                    arrTeacher_val.sort()
                    //print("Section")
                    //print(arrSection_val)
                    //print("Teacher")
                    //print(arrTeacher_val)
                    self.sectionId = arrSectionId_val
                    self.sectionName = arrSection_val
                    self.teacherName = arrTeacher_val
                    self.section_dict = dict_val
                }
                self.sectionCount = self.sectionName.count
                //print(self.sectionName)
                completed()
                //print ("completed the routine - section")
            })
        default:
            print("Data Not Found")
        }
    }
    
    func getSectionIdForTeacher(idName:String, dict: Dictionary<String?,[String]?>?) -> String {
        for (key, value) in dict! {
            if (value![1] == idName) {
                return key!
            }
        }
        return "Unknown"
    }
    
    func formatCalendar() {
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
                        dateCount.append(dateFormatterPrint.string(from: new_date))
                    } else {
                       print("There was an error decoding the string")
                    }
                }
            }
        }
    }
 }


