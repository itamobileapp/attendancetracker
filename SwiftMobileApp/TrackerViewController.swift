//
//  TrackerViewController.swift
//  test
//
//  Created by Sankar Ramanathan on 6/16/21.
//  Copyright © 2021 Sankar Ramanathan. All rights reserved.
//

import UIKit


class AttendanceTableViewCell : UITableViewCell {
    @IBOutlet weak var ddlAttendanceStatus: UIPickerView!
    @IBOutlet weak var lblStudentName: UILabel!
    
    
}


let dataSourceAttendanceStatus = ["Present", "Absent", "Tardy"]

class TrackerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var names: [String] = ["Ahilan S.", "Akshita K.", "Anish G.",
                           "Anish M.", "Divya S.", "Indhra K.",
    "Krishna S.","Krithika K.", "Pranith R.", "Rahul T.", "Sahana S."]
    
    
    @IBOutlet weak var lblAttendanceInfo: UILabel!
    @IBOutlet weak var btnCancelNo: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCancelYes: UIButton!
    @IBOutlet weak var lblMessage: UILabel!

    var yesButtonClicked = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        btnSubmit.layer.masksToBounds = true
        btnSubmit.layer.cornerRadius = 10
        btnCancel.layer.masksToBounds = true
        btnCancel.layer.cornerRadius = 10
        btnCancelYes.layer.masksToBounds = true
        btnCancelYes.layer.cornerRadius = 10
        btnCancelNo.layer.masksToBounds = true
        btnCancelNo.layer.cornerRadius = 10
        lblMessage.textColor = UIColor.systemGreen

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AttendanceTableViewCell
        
        cell.lblStudentName?.text = "\(names[indexPath.row])"
        
        cell.ddlAttendanceStatus.dataSource = self
        cell.ddlAttendanceStatus.delegate = self
        
        cell.lblStudentName.layer.cornerRadius = 10
        cell.lblStudentName.layer.masksToBounds = true

        
        if (yesButtonClicked) {
            //put working code here
            cell.ddlAttendanceStatus.selectRow(0, inComponent: 0, animated: false)
        }

        return cell
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
                attendanceCell.ddlAttendanceStatus.selectRow (0, inComponent:0, animated:true)
            }
    }
    
    @IBAction func clickCancel(_ sender: Any) {
        lblMessage.text = "Are you sure?"
        lblMessage.isHidden = false
        btnCancelNo.isHidden = false
        btnCancelYes.isHidden = false
    }
    
    
    @IBAction func clickSubmit(_ sender: Any) {
        lblMessage.text = "Information Entered Successfully"
        lblMessage.isHidden = false
        btnCancelYes.isHidden = true
        btnCancelNo.isHidden = true
    }
}





extension TrackerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSourceAttendanceStatus.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSourceAttendanceStatus[row]
        
    }
    
    
    
}

 

