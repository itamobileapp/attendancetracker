//
//  TrackerViewController.swift
//  test
//
//  Created by Sankar Ramanathan on 6/16/21.
//  Copyright © 2021 Sankar Ramanathan. All rights reserved.
//

import UIKit


class AttendanceTableViewCell : UITableViewCell {
    @IBOutlet weak var lblStudentName: UILabel!
    @IBOutlet weak var ddlAttendanceStatus: UIPickerView!
    
    

    
    
}


let dataSourceAttendanceStatus = ["Present", "Absent", "Tardy"]




class TrackerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var names: [String] = ["Ahilan S.", "Akshita K.", "Anish G.",
                           "Anish M.", "Divya S.", "Indhra K.",
    "Krishna S.","Krithika K.", "Pranith R.", "Rahul T.", "Sahana S."]
    
    
    @IBOutlet weak var lblAttendanceInfo: UILabel!
    
    @IBOutlet weak var lblTrackerMessage: UILabel!
    @IBOutlet weak var btnTrackerSubmit: UIButton!
    @IBOutlet weak var btnTrackerCancel: UIButton!
    @IBOutlet weak var btnTrackerCancelYes: UIButton!
    @IBOutlet weak var btnTrackerCancelNo: UIButton!
    
    var yesButtonClicked = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AttendanceTableViewCell
        
        cell.lblStudentName?.text = "\(names[indexPath.row])"
        
        cell.ddlAttendanceStatus.dataSource = self
        cell.ddlAttendanceStatus.delegate = self
        
        if (yesButtonClicked) {
            //put working code here
            cell.ddlAttendanceStatus.selectRow(0, inComponent: 0, animated: false)
        }

        return cell
    }
    
    
    
    
    @IBAction func clickTrackerCancelYes(_ sender: UIButton) {
        lblTrackerMessage.isHidden = true
        btnTrackerCancelYes.isHidden = true
        btnTrackerCancelNo.isHidden = true
        yesButtonClicked = true
        
        
        
    }
    
    
    @IBAction func clickTrackerSubmit(_ sender: UIButton) {
        lblTrackerMessage.text = "Information Entered Successfully"
        lblTrackerMessage.isHidden = false
        btnTrackerCancelYes.isHidden = true
        btnTrackerCancelNo.isHidden = true
        
        
    }
    
    @IBAction func clickTrackerCancel(_ sender: UIButton) {
        lblTrackerMessage.text = "Are you sure?"
        lblTrackerMessage.isHidden = false
        btnTrackerCancelNo.isHidden = false
        btnTrackerCancelYes.isHidden = false
    }
    
    
    @IBAction func clickTrackerCancelNo(_ sender: UIButton) {
        lblTrackerMessage.isHidden = true
        btnTrackerCancelYes.isHidden = true
        btnTrackerCancelNo.isHidden = true
        
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

 

