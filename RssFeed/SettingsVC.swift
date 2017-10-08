//
//  SettingsVC.swift
//  RssFeed
//
//  Created by Gopalsamy A on 07/10/17.
//  Copyright © 2017 Gopalsamy A. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import GoogleSignIn

class SettingsVC: UIViewController
{
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnTheHindu: UIButton!
    @IBOutlet weak var btnTimesOfIndia: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        let strName = userDefaults.object(forKey: "Name") as! String
        let strEmail = userDefaults.object(forKey: "Email") as! String
        let strImageURL = userDefaults.object(forKey: "Image") as! String
        
        lblName.text = "Hi " + strName
        lblEmail.text = strEmail
        imgProfile.sd_setImage(with: URL(string: strImageURL ), placeholderImage: UIImage(named: "UserPlaceHoder"))
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height/2
        imgProfile.clipsToBounds = true
        
        // Do any additional setup after loading the view.
        
        if ((userDefaults.value(forKey: "Feed") as? String) == "2")
        {
            btnTimesOfIndia.isSelected = true
            btnTheHindu.isSelected = false
        }
        else
        {
            btnTimesOfIndia.isSelected = false
            btnTheHindu.isSelected = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTheHindu(_sende: Any)
    {
        let defaults = UserDefaults.standard
        defaults.set("1", forKey: "Feed")
        defaults.synchronize()
        
        btnTimesOfIndia.isSelected = false
        btnTheHindu.isSelected = true
        
         _ = navigationController?.popViewController(animated: true)
        
    }
    @IBAction func onTimesOfIndia(_sende: Any)
    {
        let defaults = UserDefaults.standard
        defaults.set("2", forKey: "Feed")
        defaults.synchronize()
        
        btnTimesOfIndia.isSelected = true
        btnTheHindu.isSelected = false
        
         _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func onLogout(_ sender: Any)
    {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        try! Auth.auth().signOut()
        
        GIDSignIn.sharedInstance().signOut()
        
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "Name")
        defaults.set("", forKey: "Email")
        defaults.set("", forKey: "Image")
        defaults.set("no", forKey: "isLogin")
        defaults.synchronize()
        
       self.performSegue(withIdentifier: "ToLogin", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
