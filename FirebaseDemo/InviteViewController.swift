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
import MessageUI

class InviteViewController: ViewController,CNContactPickerDelegate, MFMessageComposeViewControllerDelegate {
    
    @IBAction func click_Contact(_ sender: Any) {
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        self.present(cnPicker, animated: true, completion: nil)
    }
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        
        var phoneNumberArray=[String]()
        contacts.forEach { contact in
            
            
            for number in contact.phoneNumbers {
                let phoneNumber = number.value.value(forKey: "digits")
                var aa=String(describing: phoneNumber)
                var bb=aa.components(separatedBy: "(")[1]
                var cc = bb.components(separatedBy: ")")[0]

                print("number is = \(phoneNumber)")
                phoneNumberArray.append(cc)
                
                //s

                
                
            }
            
            
            
            
        }
        picker.dismiss(animated: true, completion: nil)
        
        var messageVC = MFMessageComposeViewController()
        
        messageVC.body = "Enter a message";
        messageVC.recipients = phoneNumberArray
        messageVC.messageComposeDelegate = self;
        
        self.present(messageVC, animated: false, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
        picker.dismiss(animated: true, completion: nil)
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
}



