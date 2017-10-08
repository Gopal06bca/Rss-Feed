//
//  HomeVC.swift
//  RssFeed
//
//  Created by Gopalsamy A on 07/10/17.
//  Copyright © 2017 Gopalsamy A. All rights reserved.
//

import UIKit
import Foundation
import NVActivityIndicatorView
import ReachabilitySwift
import Toaster
import FeedKit


class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {

    @IBOutlet weak var tableHome: UITableView!
    var arrRes = [[String:AnyObject]]()
    var timer = Timer()
    let strTheHindu = "http://www.thehindubusinessline.com/news/?service=rss"
    let strTimesOfIndia = "https://timesofindia.indiatimes.com/rssfeedstopstories.cms"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.setHidesBackButton(true, animated:true);
       
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.startAnimating(CGSize.init(width: 60, height: 60), message: "", type: NVActivityIndicatorType(rawValue: 22)!)
        self.onApiCall()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSettings(_sender: Any)
    {
        self.performSegue(withIdentifier: "ToSettings", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func onApiCall()
    {
        self.CheckNetwork()

        var feedURL = URL(string: strTheHindu)!
        let userDefaults = UserDefaults.standard
        if ((userDefaults.value(forKey: "Feed") as? String) == "2")
        {
            feedURL = URL(string: strTimesOfIndia)!
            self.title = "Times Of India"
        }
        else
        {
            feedURL = URL(string: strTheHindu)!
            self.title = "The Hindu"
        }
       
        let parser = FeedParser(URL: feedURL) // or FeedParser(data: data)
        // Parse asynchronously, not to block the UI.
        parser?.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            // Do your thing, then back to the Main thread
            DispatchQueue.main.async {
                // ..and update the UI
                self.stopAnimating()
                let result = parser?.parse()
                
                if result?.rssFeed?.items?.count != 0
                {
                    self.arrRes.removeAll()
                    let items = (result?.rssFeed?.items)
                    
                    for item in items!
                    {
                        var strTitle = ""
                        var strDescription = ""
                        var date = Date()
                        if item.title != nil
                        {
                            strTitle = item.title!
                        }
                        if item.description != nil
                        {
                            strDescription = item.description!
                        }
                        if item.pubDate != nil
                        {
                            date = item.pubDate!
                        }
                        
                        var dictRes = NSMutableDictionary()
                        dictRes = [
                            "title":  strTitle,
                            "description": strDescription,
                             "date": date,
                        ]
                        
                        self.arrRes.append(dictRes as! [String : AnyObject])
                    }
                    
                    self.tableHome.delegate = self
                    self.tableHome.dataSource = self
                    self.tableHome.reloadData()
                    self.tableHome.setContentOffset(.zero, animated: true)
                   
                }
                
                self.timer.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(HomeVC.onApiCall), userInfo: nil, repeats: false)
            }
        }
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
            self.stopAnimating()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrRes.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell:UITableViewCell = UITableViewCell()
        
        let cell:HomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell")as! HomeTableViewCell
        
        let dict = arrRes[indexPath.row] as Dictionary<String,Any>
        cell.lblTitle.text = dict["title"] as? String
        cell.lblDescription.text = dict["description"] as? String
        
        let date = dict["date"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        cell.lblTime.text = dateFormatter.string(from: date! as! Date)
        
        cell.cardView.layer.cornerRadius = 5
        cell.cardView.layer.masksToBounds = true
        cell.cardView.layer.borderColor  =  UIColor.lightGray.cgColor
        cell.cardView.layer.borderWidth = 0.4
        cell.cardView.layer.shadowOpacity = 0.5
        cell.cardView.layer.shadowColor =  UIColor.lightGray.cgColor
        cell.cardView.layer.shadowRadius = 3.0
        cell.cardView.layer.shadowOffset = CGSize(width:5, height: 5)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
   
    
}
