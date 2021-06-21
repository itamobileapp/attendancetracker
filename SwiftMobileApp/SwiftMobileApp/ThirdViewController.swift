//
//  ThirdViewController.swift
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




class ThirdViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var names: [String] = ["Karthik", "Keerthi", "Amma", "Appa"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AttendanceTableViewCell
        
        cell.lblStudentName?.text = "\(names[indexPath.row])"
        
        cell.ddlAttendanceStatus.dataSource = self
        cell.ddlAttendanceStatus.delegate = self
        

        return cell
    }
    

}



//class SecondViewController : UIPickerViewDataSource, UIPickerViewDelegate {

    

    //func numberOfComponents(in pickerView: UIPickerView) -> Int {
   //     return 1
   // }
    
  //  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
  //      return pickerTitles.count
  //  }
  

//}

extension ThirdViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
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

 

