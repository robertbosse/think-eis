//
//  EmployeesViewController
//  IBM-EIS
//

import UIKit

class EmployeesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView?
    var tableController: UITableViewController?
    var employeeData: [EmployeeFromAll]?
    
    var refCtrl: UIRefreshControl?
    
    var shouldRefresh: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView?.delegate = self
        tableView?.addSubview(self.refreshControl)
        
        placeAddButton()
        getAllEmployees()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if shouldRefresh {
            handleRefresh(refreshControl)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func placeAddButton() {
        let addButton = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.plain, target: self, action: Selector("gotoAddEmployee"))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    // Get all employee data from API
    func getAllEmployees() {
        //Implementing URLSession
        let urlString = "http://localhost:9000/employees"
        
        guard let url = URL(string: urlString) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                self.employeeData = try JSONDecoder().decode([EmployeeFromAll].self, from: data)
                
                //Get back to the main queue
                DispatchQueue.main.async {
                    if self.refCtrl != nil && (self.refCtrl?.isRefreshing)! {
                        self.refCtrl?.endRefreshing()
                    }
                    
                    self.tableView?.reloadData()
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
        //End implementing URLSession
    }
    
    // Get specific employee details data from API
    func getEmployee(id: String)  {
        //Implementing URLSession
        let urlString = "http://localhost:9000/employees/id/" + id
        
        guard let url = URL(string: urlString) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let employeeDetails = try JSONDecoder().decode(EmployeeDetails.self, from: data)
                
                //Get back to the main queue
                DispatchQueue.main.async {
                    let viewController: EmployeeDetailsViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "employeeDetailsVC") as! EmployeeDetailsViewController
                    viewController.employeeDetails = employeeDetails
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
        //End implementing URLSession
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // TableView delegate and data source logic
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let employees = employeeData {
            return employees.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell") as! UITableViewCell
        
        cell.textLabel?.text = employeeData?[indexPath.row].last_name
        cell.detailTextLabel?.text = employeeData?[indexPath.row].first_name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "showEmployeeDetail", sender: self)
        getEmployee(id: (employeeData?[indexPath.row]._id)!)
    }
    
    // Pull to refresh logic
    @objc
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        getAllEmployees()
        refCtrl = refreshControl
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(EmployeesViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()

    // Navigate to add employee
    @objc
    func gotoAddEmployee() {
        let viewController: UIViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addEmployeeVC")
        navigationController?.pushViewController(viewController, animated: true)
    }
}

