//
//  LoginVC.swift
//  RssFeed
//
//  Created by Gopalsamy A on 07/10/17.
//  Copyright © 2017 Gopalsamy A. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import ReachabilitySwift
import Toaster

class LoginVC: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
           GIDSignIn.sharedInstance().delegate = self
        // Do any additional setup after loading the view.
        
        btnLogin.layer.cornerRadius = 5
        btnLogin.layer.masksToBounds = true
        btnLogin.layer.borderColor  =  UIColor.lightGray.cgColor
        btnLogin.layer.borderWidth = 0.4
        btnLogin.layer.shadowOpacity = 0.5
        btnLogin.layer.shadowColor =  UIColor.lightGray.cgColor
        btnLogin.layer.shadowRadius = 3.0
        btnLogin.layer.shadowOffset = CGSize(width:5, height: 5)
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
         self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onGoogleSignIn(_ sender: Any)
    {
        self.CheckNetwork()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?)
    {
        if user == nil
        {
            print("No User")
        }
        else{
          //  let userId = user.userID
            let strName = user.profile.name
            let strEmail = user.profile.email
            var strImageURL = ""
            if user.profile.hasImage
            {
                let pic = user.profile.imageURL(withDimension: 100)
                strImageURL = pic!.absoluteString
                
            }
            
            let defaults = UserDefaults.standard
            defaults.set(strName, forKey: "Name")
            defaults.set(strEmail, forKey: "Email")
            defaults.set(strImageURL, forKey: "Image")
            defaults.set("yes", forKey: "isLogin")
            defaults.synchronize()
            
            self.performSegue(withIdentifier: "ToHome", sender: self)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
       
    }

    func CheckNetwork()
    {
        let reachability = Reachability()!
        
        if reachability.isReachable
        {
            print("Network reachable")
        }
        else
        {
            Toast(text: "Please check your internet connection", duration: 3).show()
            let appearance = ToastView.appearance()
            appearance.backgroundColor = UIColor.darkGray
            appearance.textColor = UIColor.white
            appearance.font = UIFont.systemFont(ofSize: 15)
            appearance.textInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
            appearance.bottomOffsetPortrait = 50
            appearance.cornerRadius = 15
            print("Network not reachable")
        }
        
    }
    
   /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    
 */
}
