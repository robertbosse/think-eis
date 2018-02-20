//
//  AddEmployeeViewController.swift
//  IBM-EIS
//
//  Created by robert on 1/25/18.
//  Copyright © 2018 robert. All rights reserved.
//

import Foundation
import UIKit

class AddEmployeeViewController: UIViewController {
    
    // Basic Info
    @IBOutlet var firstNameTextField: UITextField?
    @IBOutlet var lastNameTextField: UITextField?
    @IBOutlet var phoneTextField: UITextField?
    @IBOutlet var roleTextField: UITextField?
    @IBOutlet var emailTextField: UITextField?
    
    // Address Info
    @IBOutlet var streetTextField: UITextField?
    @IBOutlet var zipcodeText: UITextField?
    @IBOutlet var stateTextField: UITextField?
    @IBOutlet var countryTextField: UITextField?
    
    @IBOutlet var payTextField: UITextField?
    @IBOutlet var stockTextField: UITextField?
    
    @IBOutlet var childrenTextField: UITextField?
    @IBOutlet var marriedSwitch: UISwitch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        placeCreateButton()
    }
    
    func placeCreateButton() {
        let createButton = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.plain, target: self, action: Selector("createEmployee"))
        self.navigationItem.rightBarButtonItem = createButton
    }
    
    @objc
    func createEmployee() {
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
        
        if let zipcode = Int64(zipcodeText?.text ?? "55555") {
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
          
            //Implementing URLSession
            let urlString = "http://localhost:9000/employees"
            
            guard let url = URL(string: urlString) else { return }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "post"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonData
            
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
        } catch let jsonError {
            print(jsonError)
        }

    }
    
}
