//
//  DetailViewController.swift
//  assignment5
//
//  Created by Betty on 2/6/16.
//  Copyright © 2016 Betty. All rights reserved.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController, SFSafariViewControllerDelegate {

    @IBOutlet weak var SegDateLabel: UILabel!
    @IBOutlet weak var SegTitleLabel: UILabel!
    @IBOutlet weak var SegAuthorLabel: UILabel!
    @IBOutlet weak var SegBodyLabel: UILabel!
    
    
    
    var issue: [String: AnyObject] = [String: AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(issue)
        SegTitleLabel.text = issue["title"] as? String
        SegDateLabel.text = issue["created_at"] as? String
        SegAuthorLabel.text = issue["user"]!["login"] as? String
        SegBodyLabel.text = issue["body"] as? String
        
        openWithSafariVC()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openWithSafariVC(){
        print("--> openWithSafari")
        let num = issue["number"] as? Int
        if let num = num as Int! {
            let url_num = "http://github.com/uchicago-mobi/2016-Winter-Forum/issues/\(num)"
            let url = NSURL(string: url_num)
            let svc = SFSafariViewController(URL: url!)
            svc.delegate = self
            // self.navigationController?.pushViewController(svc, animated: true)
            self.presentViewController(svc, animated: true, completion: nil)
            print("--> close: openWithSafari")
        }
    }
    
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        openWithSafariVC(indexPath.row)
//    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
