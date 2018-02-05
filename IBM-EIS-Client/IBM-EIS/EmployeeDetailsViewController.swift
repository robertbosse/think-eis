//
//  EmployeeDetailsViewController.swift
//  IBM-EIS
//
//  Created by robert on 1/25/18.
//  Copyright © 2018 robert. All rights reserved.
//

import Foundation

import UIKit

class EmployeeDetailsViewController: UIViewController {
    
    // Basic Info TextFields
    @IBOutlet var firstNameTextField: UITextField?
    @IBOutlet var lastNameTextField: UITextField?
    @IBOutlet var phoneTextField: UITextField?
    @IBOutlet var roleTextField: UITextField?
    @IBOutlet var emailTextField: UITextField?
    
    // Address Info TextFields
    @IBOutlet var streetTextField: UITextField?
    @IBOutlet var zipcodeTextField: UITextField?
    @IBOutlet var stateTextField: UITextField?
    @IBOutlet var countryTextField: UITextField?
    
    @IBOutlet var payTextField: UITextField?
    @IBOutlet var stockTextField: UITextField?
    
    @IBOutlet var childrenTextField: UITextField?
    @IBOutlet var marriedTextField: UITextField?
    
    @IBOutlet var deleteSaveButton: UIButton?
    
    var employeeDetails: EmployeeDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        placeUpdateButton()
        insertEmployeeDetails()
        
        deleteSaveButton?.addTarget(self, action: "buttonClicked", for: UIControlEvents.touchUpInside)
    }
    
    func insertEmployeeDetails() {
        firstNameTextField?.text = employeeDetails?.employee.first_name
        lastNameTextField?.text = employeeDetails?.employee.last_name
        phoneTextField?.text = employeeDetails?.employee.phone.description
        roleTextField?.text = employeeDetails?.employee.role
        emailTextField?.text = employeeDetails?.employee.email
        
        streetTextField?.text = employeeDetails?.address.street
        zipcodeTextField?.text = employeeDetails?.address.zipcode.description
        stateTextField?.text = employeeDetails?.address.state
        countryTextField?.text = employeeDetails?.address.country
        
        payTextField?.text = employeeDetails?.compensation.pay.description
        stockTextField?.text = employeeDetails?.compensation.stock.description
        
        childrenTextField?.text = employeeDetails?.family.childrens.description
        marriedTextField?.text = employeeDetails?.family.marital_status.description
        
        enableTextFields(isEnabled: false)
    }
    
    func enableTextFields(isEnabled: Bool) {
        firstNameTextField?.isEnabled = isEnabled
        lastNameTextField?.isEnabled = isEnabled
        phoneTextField?.isEnabled = isEnabled
        roleTextField?.isEnabled = isEnabled
        emailTextField?.isEnabled = isEnabled
        
        streetTextField?.isEnabled = isEnabled
        zipcodeTextField?.isEnabled = isEnabled
        stateTextField?.isEnabled = isEnabled
        countryTextField?.isEnabled = isEnabled
        
        payTextField?.isEnabled = isEnabled
        stockTextField?.isEnabled = isEnabled
        
        childrenTextField?.isEnabled = isEnabled
        marriedTextField?.isEnabled = isEnabled
    }
    
    func placeUpdateButton() {
        let addButton = UIBarButtonItem(title: "Update", style: UIBarButtonItemStyle.plain, target: self, action: Selector("enableUpdateEmployee"))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func placeCanelButton() {
        let addButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: Selector("cancelUpdateEmployee"))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func placeSaveText() {
        deleteSaveButton?.setTitle("Save", for: UIControlState.normal)
    }
    
    func placeDeleteText() {
        deleteSaveButton?.setTitle("Delete", for: UIControlState.normal)
    }
    
    @objc
    func buttonClicked() {
        let title:String = (deleteSaveButton?.titleLabel?.text)!

        if(title == "Delete") {
            deleteEmployee()
        } else if(title == "Save") {
            saveEmployee()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Update employee with API
    @objc
    func enableUpdateEmployee() {
        enableTextFields(isEnabled: true)
        placeCanelButton()
        placeSaveText()
    }
    
    // Update employee with API
    @objc
    func cancelUpdateEmployee() {
        insertEmployeeDetails()
        enableTextFields(isEnabled: false)
        placeUpdateButton()
        placeDeleteText()
    }
    
    // Delete employee from API
    @objc
    func deleteEmployee() {
        //Implementing URLSession
        let urlString = "http://localhost:9000/employees/id/" + (employeeDetails?.employee._id)!
        
        guard let url = URL(string: urlString) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "delete"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            if let resp = response as? HTTPURLResponse {
                if resp.statusCode > 199 && resp.statusCode < 400 {
                    DispatchQueue.main.async {
                        // Go back to the previous ViewController
                        let rootCtrler = self.navigationController?.viewControllers[0] as! EmployeesViewController
                        rootCtrler.shouldRefresh = true
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            
            }.resume()
        //End implementing URLSession
    }
    
    // Save employee with API
    @objc
    func saveEmployee() {
        //Implementing URLSession
        
        //End implementing URLSession
    }
}
