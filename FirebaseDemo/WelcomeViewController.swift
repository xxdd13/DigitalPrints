//
//  WelcomeViewController.swift
//  FirebaseDemo
//
//  Created by Simon Ng on 5/1/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import NVActivityIndicatorView
import Alamofire

class WelcomeViewController: UIViewController,NVActivityIndicatorViewable  {
    override func viewDidAppear(_ animated: Bool) {
        guard let accessToken = FBSDKAccessToken.current() else {
            print("Failed to get access token")
            return
        }
        self.loadingShow(size:5)
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                
                
                return
            }
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ""
        
    }
    
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func unwindtoWelcomeView(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func loadingShow(size:Int){
        
        let alert = UIAlertController(title: nil, message: "Logging in...", preferredStyle: .alert)
        
        let frame = CGRect(x: 10, y: 5, width: 50, height: 50)
        
        let type = NVActivityIndicatorType(rawValue: 30)
        let loadingIndicator = NVActivityIndicatorView(frame: frame, type: type, color: UIColor(hue: 0.5028, saturation: 1, brightness: 0.82, alpha: 1.0), padding: CGFloat(10))
        
        
        
        if size == 5{
            let frame = CGRect(x: 10, y: 5, width: 180, height: 180)
            let size = CGSize(width: 320, height: 320)
            startAnimating(size, message: "Loading...",type: type,color: UIColor(hue: 0.5028, saturation: 1, brightness: 0.82, alpha: 1.0))
        }
        else{
            loadingIndicator.startAnimating();
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
        }
        //alert.view.addSubview(loadingIndicator)
        //present(alert, animated: true, completion: nil)

    
    }
    @IBAction func facebookLogin(sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            self.loadingShow(size:1)
            
            // Perform login by calling Firebase APIs
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                    return
                }
                
                // Present the main view
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                    
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                    
                    
                    
                }
                
            })
            
        }   
    }
    

    
}


