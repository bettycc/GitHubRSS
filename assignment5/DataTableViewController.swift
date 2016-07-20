//
//  DataTableViewController.swift
//  assignment5
//
//  Created by Betty on 2/4/16.
//  Copyright © 2016 Betty. All rights reserved.
//

import UIKit
import SafariServices

class DataTableViewController: UITableViewController, SFSafariViewControllerDelegate {

    //Properties
    let container: UIView = UIView()

    
    var url: String?
    var issues:[[String: AnyObject]]?{
        willSet(newValue){
        //called before property is set
            //issues?.append(newValue)
            print("willSet 123 ")
        }
        didSet{
        //called after property is set
            print("didset 456 \(oldValue)")
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    
    var footer = "footer-test"
    var formattedTimestamp: String {
        get {
        // code to execute when getting
        // The getter must return a value of the same type
            let currentDate = NSDate()
            footer = "Updated at \(currentDate)"
            return footer
        }
        set(set_footer) {
        // code to execute when setting
            footer =  set_footer
        }
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make a request for all open data from GitHub
      
        showActivityIndicatory()
        
        issuesRequestion(url!) { (response) -> Void in

            guard let response = response else {
                return
            }
            
            self.issues = response
            
            self.container.removeFromSuperview()
            
            self.refreshTable()
            
//            dispatch_async(dispatch_get_main_queue()) {
//                self.tableView.reloadData()
//            }
        }
        
        
        //add reshresh
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        //attributes:http://nshipster.com/uiappearance/
        //attributes:http://stackoverflow.com/questions/24687238/changing-navigation-bar-color-in-swift
        navigationController!.navigationBar.barTintColor = UIColor.yellowColor()
        UINavigationBar.appearance().tintColor = UIColor.greenColor()
        tabBarController!.tabBar.barTintColor = UIColor.brownColor()
        
      
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       // showActivityIndicatory()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       // showActivityIndicatory()
    }

    
    
    
    func refreshTable() {
        // For debugging, iterate through each issue and print the user id and the
        // title to the console.  You do not need to include this in your
        // application.
        for issue in issues! {
            if let title = issue["title"] as? String,
                user = issue["user"]!["login"] as? String {
                    print("\(user) - \(title)")
            }
        }
    }

    func issuesRequestion(urlString: String, completion:([[String: AnyObject]]?) -> Void) {
        
        // Test that we can convert the `String` into an `NSURL` object.  If we can
        // not, then crash the application.
        guard let url = NSURL(string: urlString)  else {
            fatalError("No URL")
        }
        
        // Create a `NSURLSession` object
        let session = NSURLSession.sharedSession()
        
        // Create a task for the session object to complete
        let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            
            // Check for errors that occurred during the download.  If found, execute
            // the completion block with `nil`
            guard error == nil else {
                print("error: \(error!.localizedDescription): \(error!.userInfo)")
                
                let alertController_0 = UIAlertController(title: "API Request Status", message: "Can't get the API request!", preferredStyle: .Alert)
                let defaultAction_0 = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController_0.addAction(defaultAction_0)
                
                self.presentViewController(alertController_0, animated: true, completion: nil)
                completion(nil)
                return
            }
            
            // Print the response headers (for debugging purpose only)
            print(response)
            
            // Test that the data has a value and unwrap it to the variable `let`.  If
            // it is `nil` than pass `nil` to the completion closure.
            guard let data = data else {
                print("There was no data")
                
                let alertController_0 = UIAlertController(title: "API Request Status", message: "Can't get the API request!", preferredStyle: .Alert)
                let defaultAction_0 = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController_0.addAction(defaultAction_0)
                
                self.presentViewController(alertController_0, animated: true, completion: nil)
                completion(nil)
                return
            }
            
            // Unserialze the JSON that was retrieved into an Array of Dictionaries.
            // Pass is as parameter to the completion block.
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                if let issues = json as? [[String: AnyObject]] {
                    completion(issues)
                }
            } catch {
                print("error serializing JSON: \(error)")
                completion(nil)
            }
        })
        
        // Start the downloading.  NSURLSession objects are created in the paused
        // state, so to start it we need to tell it to *resume*
        task.resume()
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if ((issues?.count) != nil) { NSLog("2nd method is not nil."); return (issues?.count)! }
        else{NSLog("2nd method is nil."); return 0  }
    }

    
    

    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        //return footer
        
        //set footer
        //self.formattedTimestamp = "refresh"
        //return self.footer
        
        return formattedTimestamp
    }
    
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        issuesRequestion(url!) { (response) -> Void in
            
            // Test that the `response` is not `nil` and unwrap it to the variable
            // response.  IF it is `nil` then return the function so that we do not
            // reload the table unnecessarily.
            guard let response = response else {
                return
            }
            
            // Set the repsonse data to the view controller's `issues` property
            self.issues = response
            
            // Call our method that will prompt the table to reload itself with the
            // updated data
            self.refreshTable()
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
            
        }
        
        refreshControl.endRefreshing()
        
        
    }
    
    //attribute:https://coderwall.com/p/su1t1a/ios-customized-activity-indicator-with-swift
    func showActivityIndicatory() {
        print("--> show activityIndicatory")
        
        //let container: UIView = UIView()
        container.frame = CGRectMake(100, 100, 80, 80)
        container.center = CGPoint(x: 200, y: 200)
        container.backgroundColor = UIColor.redColor() // UIColor(white: 0xffffff, alpha: 0.3)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = CGPoint(x: 200, y: 200)
        loadingView.backgroundColor = UIColor(white: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 5
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.WhiteLarge
        actInd.center = CGPointMake(loadingView.frame.size.width / 2,
            loadingView.frame.size.height / 2);
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        view.addSubview(container)
        actInd.startAnimating()
        
        print("--> close activityIndicatory")
    }
    
}
