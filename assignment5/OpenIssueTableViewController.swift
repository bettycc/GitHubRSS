//
//  OpenIssueTableViewController.swift
//  assignment5
//
//  Created by Betty on 2/4/16.
//  Copyright © 2016 Betty. All rights reserved.
//

import UIKit

class OpenIssueTableViewController: DataTableViewController {
    
    

    
    override func viewDidLoad() {
        self.url = "https://api.github.com/repos/uchicago-mobi/2016-Winter-Forum/issues?state=open"
        
        super.viewDidLoad()
    }


    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "OpenIssueTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)as! OpenIssueTableViewCell
        
        
        if ((issues?.count) != nil) {
            NSLog("3rd method is not nil.")
            let issue = issues![indexPath.row]
            cell.TitleLabel.text = (issue["title"]as! String)
            cell.AuthorLabel.text = (issue["user"]!["login"]as! String)
            cell.DateLabel.text = (issue["created_at"] as! String)
            let openImage : UIImage! = UIImage(named:"ninja_w")
            cell.OpenImage.image = openImage
            
        }else{
            NSLog("3rd method is nil.")
        }
        
        return cell
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "DetailViewSeg"{
            if let destination = segue.destinationViewController as? DetailViewController{
                let path = tableView.indexPathForSelectedRow
                destination.issue = self.issues![(path?.item)!]
            }
        }
    }
//
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        openWithSafariVC(indexPath.row)
//    }

}
