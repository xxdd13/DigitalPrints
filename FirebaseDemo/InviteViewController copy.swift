//
//  InviteViewController.swift
//  FirebaseDemo
//
//  Created by Xin Ding on 27/7/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//


import UIKit
import FBSDKLoginKit
import Firebase
import ContactsUI

class InviteViewController: ViewController, UITableViewDelegate,UITableViewDataSource,CNContactPickerDelegate{
    var tableView: UITableView  =   UITableView()
    var items: [String] = ["1", "2", "3"]
    
    @IBAction func click_Contact(_ sender: Any) {
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        self.present(cnPicker, animated: true, completion: nil)
    }
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        contacts.forEach { contact in
            for number in contact.phoneNumbers {
                let phoneNumber = number.value
                print("number is = \(phoneNumber)")
            }
        }
    }
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds
        let tableWidth = screenSize.width-60
        let tableHeight = screenSize.height-40
        tableView.frame         =   CGRect(x: 30, y: 20, width: tableWidth, height: tableHeight);
        tableView.delegate      =   self as! UITableViewDelegate
        tableView.dataSource    =   self as! UITableViewDataSource
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        self.title = ""
        /*
        let params = ["fields": "id, first_name, last_name, middle_name, name, email, picture"]
        FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: params).start { (connection, result , error) -> Void in
            
            if error != nil {
                print(error!)
                print("0000000000000000000")
            }
            else {
                print(result!)
                print("11111111111111111111111")
                //Do further work with response
            }
        }
         */
        
                
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
}



