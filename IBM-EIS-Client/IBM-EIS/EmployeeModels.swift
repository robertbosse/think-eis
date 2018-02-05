import UIKit

struct EmployeeFromAll: Codable {
    var _id: String
    var first_name: String
    var last_name: String
    var phone: Int64
    var email: String
    var role: String
}

struct EmployeeDetails: Codable {
    init() {
        employee = Employee()
        address = Address()
        compensation = Compensation()
        family = Family()
        health = Health()
        photo = Photo()
    }
    
    var employee: Employee
    var address: Address
    var compensation: Compensation
    var family: Family
    var health: Health
    var photo: Photo
}

struct Employee: Codable {
    init() {
        _id = ""
        first_name = ""
        last_name = ""
        phone = 0
        email = ""
        role = ""
    }
    
    var _id: String
    var first_name: String
    var last_name: String
    var phone: Int64
    var email: String
    var role: String
}

struct Address: Codable {
    init() {
        street = ""
        state = ""
        zipcode = 0
        country = ""
    }
    
    var street: String
    var state: String
    var zipcode: Int64
    var country: String
}

struct Compensation: Codable {
    init() {
        pay = 0
        stock = 0
    }
    
    var pay: Int32
    var stock: Int32
}

struct Family: Codable {
    init() {
        childrens = 0
        marital_status = false
    }
    
    var childrens: Int
    var marital_status: Bool
}

struct Health: Codable {
    init() {
        paid_family_leave = false
        longterm_disability_plan = false
        shortterm_disability_plan = false
    }
    
    var paid_family_leave: Bool
    var longterm_disability_plan: Bool
    var shortterm_disability_plan: Bool
}

struct Photo: Codable {
    init() {
        image = ""
    }
    
    var image: String
}
