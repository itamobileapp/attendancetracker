//
//  TrackerViewController.swift
//  test
//
//  Created by Sankar Ramanathan on 6/16/21.
//  Copyright © 2021 Sankar Ramanathan. All rights reserved.
//

import UIKit


class AttendanceTableViewCell : UITableViewCell {
    @IBOutlet weak var txtStudentName: UITextField!
    @IBOutlet weak var lblStudentName: UILabel!
    var studentPickerView = UIPickerView()
    
    override func awakeFromNib() {
        studentPickerView.dataSource = self
        studentPickerView.delegate = self
        txtStudentName.inputView = studentPickerView
        txtStudentName.textAlignment = .center
    }
}


let dataSourceAttendanceStatus = ["Present", "Absent", "Tardy"]


class TrackerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var AttendanceTableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblAttendanceInfo: UILabel!
    @IBOutlet weak var btnCancelNo: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCancelYes: UIButton!
    @IBOutlet weak var lblMessage: UILabel!

    var yesButtonClicked = false
    var sectionId = ""
    var attendanceDate = ""
    var student = [String]()
    var studentName = [String]()
    var studentCount = 0
    var broken = false
    var names: [String] = [""]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSubmit.layer.masksToBounds = true
        btnSubmit.layer.cornerRadius = 10
        btnCancel.layer.masksToBounds = true
        btnCancel.layer.cornerRadius = 10
        btnCancelYes.layer.masksToBounds = true
        btnCancelYes.layer.cornerRadius = 10
        btnCancelNo.layer.masksToBounds = true
        btnCancelNo.layer.cornerRadius = 10
        lblMessage.textColor = UIColor.systemGreen
        
        let dict_section:Dictionary<String?, String?> = ["sectionid": sectionId]
        getData(dict: dict_section, trailingUrl:Utils.studentInfo) {() -> Void in
            self.AttendanceTableView.delegate = self
            self.AttendanceTableView.dataSource = self
            self.AttendanceTableView.reloadData()
        }
    }
    
    @IBAction func clickCancelNo(_ sender: Any) {
        lblMessage.isHidden = true
        btnCancelYes.isHidden = true
        btnCancelNo.isHidden = true
    }
    
    
    @IBAction func clickCancelYes(_ sender: Any) {
        lblMessage.isHidden = true
        btnCancelYes.isHidden = true
        btnCancelNo.isHidden = true
        yesButtonClicked = true
        
        let cells = self.tableView.visibleCells
            for cell in cells {
                let attendanceCell = cell as! AttendanceTableViewCell
                //attendanceCell.studentPickerView.selectRow (0, inComponent:0, animated:true)
                attendanceCell.txtStudentName.text = ""
            }
    }
    
    @IBAction func clickCancel(_ sender: Any) {
        lblMessage.text = "Are you sure?"
        lblMessage.isHidden = false
        btnCancelNo.isHidden = false
        btnCancelYes.isHidden = false
    }
    
    
    @IBAction func clickSubmit(_ sender: Any) {

        lblMessage.text = ""
        lblMessage.isHidden = false
        btnCancelYes.isHidden = true
        btnCancelNo.isHidden = true

        let cells = self.tableView.visibleCells
        for cell in cells {
            let attendanceCell = cell as! AttendanceTableViewCell
            if (attendanceCell.txtStudentName.text == "") {
                lblMessage.text = "Incomplete Information!"
                return
            }
        }
        for cell in cells {
            let attendanceCell = cell as! AttendanceTableViewCell
            if (!self.broken) {
                let studentId = Utils.getId(matchingName: attendanceCell.lblStudentName.text!, arr: self.student)
                let formattedDate = getFormattedDate(date:attendanceDate)
                let status = attendanceCell.txtStudentName.text
                
                print (studentId)
                print (formattedDate)
                print (status!)
                
                let dict:Dictionary<String?, String?> = ["studentId": studentId, "date": formattedDate, "status": status!]
                let trailingUrl:String = Utils.submitAttendance
                let request:URLRequest = Utils.createHttpRequest(dict: dict, trailingUrl: trailingUrl, method: "POST")
                Utils.sendPostRequest(request: request, completion: { (data, error) in
                    do {
                        print (type(of: data))
                        let returnVal = data
                        print (returnVal, Utils.SUCCESSFULLY_SUBMITTED, Utils.SUCCESSFULLY_UPDATED)
                        if (returnVal == Utils.SUCCESSFULLY_SUBMITTED) {
                            self.lblMessage.text = "Information Entered Successfully."
                        }
                        if (returnVal == Utils.SUCCESSFULLY_UPDATED) {
                            self.lblMessage.text = "Information Updated Successfully"
                        }
                        else {
                            self.lblMessage.text = "Unknown Error."
                            //self.broken = true
                        }
                    }
                })
            }
            else {
                return
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AttendanceTableViewCell
        
        cell.lblStudentName?.text = "\(names[indexPath.row])"
        cell.lblStudentName.layer.cornerRadius = 10
        cell.lblStudentName.layer.masksToBounds = true
        cell.txtStudentName.text = "Present"
        if (yesButtonClicked) {
            //put working code here
            cell.studentPickerView.selectRow(0, inComponent: 0, animated: false)
        }
        return cell
    }
    
    func getData(dict:Dictionary<String?, String?>?, trailingUrl: String, completed: @escaping () -> Void) {
        var arr = [String]()
        var arrName = [String]()
        let request:URLRequest = Utils.createHttpRequest(dict: dict, trailingUrl: trailingUrl, method: "GET")
        Utils.sendGetRequestSingle(request: request, completion: { (data, error) in
            do {
                for (key, value) in data {
                    arr.append("\(key):\(value)")
                    arrName.append("\(value)")
                }
                arr.sort()
                arrName.sort()
                print (arr)
                self.student = arr
                self.names = arrName
            }
            self.studentCount = self.student.count
            completed()
            print ("completed the routine - student")
        })
    }
    
   func getFormattedDate(date: String) -> String {
       let indateformat = DateFormatter()
       indateformat.dateFormat = "MMM dd,yyyy"
       let inDate = indateformat.date(from: date)
            
       let dateformat = DateFormatter()
       dateformat.dateFormat = "yyyy-MM-dd"
       return dateformat.string(from: inDate!)
   }
}

extension AttendanceTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSourceAttendanceStatus.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtStudentName.text = dataSourceAttendanceStatus[row]
        txtStudentName.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSourceAttendanceStatus[row]
    }
}

 

