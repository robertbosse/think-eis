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
    @IBOutlet var marriedSwitch: UISwitch?
    
    @IBOutlet var deleteSaveButton: UIButton?
    
    var employeeDetails: EmployeeDetails?
    
    var isSumbitting: Bool = false
    
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
        marriedSwitch?.isOn = employeeDetails?.family.marital_status.description == "true" ? true : false
        
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
        marriedSwitch?.isEnabled = isEnabled
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
        var resourceFileDictionary: NSDictionary?
        
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            resourceFileDictionary = NSDictionary(contentsOfFile: path)
            
            if let resourceFileDictionaryContent = resourceFileDictionary {
                
                //Implementing URLSession
                let urlString = (resourceFileDictionaryContent.object(forKey: "ServerIP")! as! String) + "/employees/id/" + (employeeDetails?.employee._id)!
                
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
        }
    }
    
    // Save employee with API
    @objc
    func saveEmployee() {
        if(!isSumbitting) {
            isSumbitting = true
            self.enableTextFields(isEnabled: false)
            
            var employeeData: EmployeeDetails = EmployeeDetails()
            
            if let lastName = lastNameTextField?.text {
                employeeData.employee.last_name = lastName
            }
            
            if let firstName = firstNameTextField?.text {
                employeeData.employee.first_name = firstName
            }
            
            if let phone = Int64(phoneTextField?.text ?? "5555555555") {
                employeeData.employee.phone = phone
            }
            
            if let email = emailTextField?.text {
                employeeData.employee.email = email
            }
            
            if let role = roleTextField?.text {
                employeeData.employee.role = role
            }
            
            
            if let street = streetTextField?.text {
                employeeData.address.street = street
            }
            
            if let zipcode = Int64(zipcodeTextField?.text ?? "55555") {
                employeeData.address.zipcode = zipcode
            }
            
            if let state = stateTextField?.text {
                employeeData.address.state = state
            }
            
            if let country = countryTextField?.text {
                employeeData.address.country = country
            }
            
            
            if let pay = Int32(payTextField?.text ?? "0")  {
                employeeData.compensation.pay = pay
            }
            
            if let stock = Int32(stockTextField?.text ?? "0") {
                employeeData.compensation.stock = stock
            }
            
            
            if let childrens = Int(childrenTextField?.text ?? "0") {
                employeeData.family.childrens = childrens
            }
            
            employeeData.family.marital_status = ((marriedSwitch?.isOn.description) != nil)
            
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let jsonData = try JSONEncoder().encode(employeeData)
                
                var resourceFileDictionary: NSDictionary?
                
                if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
                    resourceFileDictionary = NSDictionary(contentsOfFile: path)
                    
                    if let resourceFileDictionaryContent = resourceFileDictionary {
                        
                        //Implementing URLSession
                        let urlString = (resourceFileDictionaryContent.object(forKey: "ServerIP")! as! String) + "/employees/id/" + (employeeDetails?.employee._id)!
                        
                        guard let url = URL(string: urlString) else { return }
                        var urlRequest = URLRequest(url: url)
                        urlRequest.httpMethod = "put"
                        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        urlRequest.httpBody = jsonData
                        
                        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                            self.isSumbitting = false
                            self.enableTextFields(isEnabled: true)
                            
                            if error != nil {
                                print(error!.localizedDescription)
                            }
                            
                            if let resp = response as? HTTPURLResponse {
                                if resp.statusCode > 199 && resp.statusCode < 400 {
                                    
                                }
                            }
                            
                            }.resume()
                        //End implementing URLSession
                        
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
        }
    }
}
