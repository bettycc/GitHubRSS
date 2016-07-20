//
//  CircleViewController.swift
//  assignment5
//
//  Created by Betty on 2/5/16.
//  Copyright © 2016 Betty. All rights reserved.
//

import UIKit

class CircleViewController: UIViewController {

    // MARK: - Properties
    /// The array of dictionaries that will hold all of our issues
    var issues:[[String: AnyObject]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //attributes_draw circle
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 200,y: 200), radius: CGFloat(100), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.CGPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.redColor().CGColor
        //you can change the line width
        shapeLayer.lineWidth = 3.0
        
        view.layer.addSublayer(shapeLayer)
        
        let circlePath_2 = UIBezierPath(arcCenter: CGPoint(x: 200,y: 200), radius: CGFloat(150), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer_2 = CAShapeLayer()
        shapeLayer_2.path = circlePath_2.CGPath
        
        shapeLayer_2.fillColor = UIColor.clearColor().CGColor
        shapeLayer_2.strokeColor = UIColor.greenColor().CGColor
        shapeLayer_2.lineWidth = 3.0
        
        view.layer.addSublayer(shapeLayer_2)
        
        
        // Make a request for all open data from GitHub
        issuesRequestion("https://api.github.com/repos/uchicago-mobi/2016-Winter-Forum/issues?state=all") { (response) -> Void in
            
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
            //
            //            dispatch_async(dispatch_get_main_queue()) {
            //                self.tableView.reloadData()
            //            }
            
            //create label programatically
            let open_label = UILabel(frame: CGRectMake(140, 50, 370, 250))
            let close_label = UILabel(frame: CGRectMake(140, 100, 370, 250))
            open_label.textColor = UIColor.blueColor()
            open_label.text = "I'am a test label"
            close_label.textColor = UIColor.blackColor()
            
            var openCount = 0
            var closeCount = 0
            //count the number of open issues and close issues
            if ((self.issues?.count) != nil) {
                NSLog("count is not nil.")
                //create a for loop to track
                for item in self.issues!{
                    print("enter the array")
                    
                    for key in item.keys{
                        print("key is \(key)")
                        if key == "state"{
                            if item[key]as! String == "open"{
                                print("open")
                                openCount = openCount + 1
                            }else{
                                closeCount = closeCount + 1
                            }
                        }
                    }
                    
                }
            }else   { NSLog("count is nil.")}
            
            open_label.text = "\(openCount) Open Issues"
            close_label.text = "\(closeCount) Close Issues"
            self.view.addSubview(open_label)
            self.view.addSubview(close_label)
            
        }
        
        
    }
    
    //
    // MARK: - Table View Refresh
    //
    
    /// Reload the table with newly downloaded data.  This should be called when
    /// the table is first shown onscreen and when the user conducts a
    /// pull-to-refresh operation.
    ///
    /// - Note: You should be telling you table to reload here
    /// - Attributions: Lecture slides and assignment write-up
    ///
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
    
    //
    // MARK: - Data Retrieval and Processing
    //
    
    /// Make a request using GitHub API v3 for issues.  This will download the
    /// issues, test that the data is valid, unserialize the JSON into an `Array`
    /// of `Dictionary`'s and then execute the completion closure.
    ///
    /// - Parameter urlString: A `String` of the URL holding the JSON
    /// - Parameter completion: A closure to run on the converted JSON
    /// - Attributions: Assignment write-up
    ///
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
                completion(nil)
                return
            }
            
            // Print the response headers (for debugging purpose only)
            print(response)
            
            // Test that the data has a value and unwrap it to the variable `let`.  If
            // it is `nil` than pass `nil` to the completion closure.
            guard let data = data else {
                print("There was no data")
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
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

}
