//
//  AllIssueTableViewController.swift
//  assignment5
//
//  Created by Betty on 2/4/16.
//  Copyright © 2016 Betty. All rights reserved.
//

import UIKit

class AllIssueTableViewController: DataTableViewController {

    override func viewDidLoad() {
        
         self.url = "https://api.github.com/repos/uchicago-mobi/2016-Winter-Forum/issues?state=all"
        
        super.viewDidLoad()

        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "AllIssueTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)as! AllIssueTableViewCell
        
        if ((issues?.count) != nil) {
            NSLog("all-3rd method is not nil.")
            var issue = issues![indexPath.row]
            cell.AllTitleLabel.text = (issue["title"]as! String)
            cell.AllAuthorLabel.text = (issue["user"]!["login"]as! String)
            cell.AllDateLabel.text = (issue["created_at"] as! String)
            let openImage : UIImage! = UIImage(named:"ninja_w")
            let closeImage : UIImage! = UIImage(named:"ninja_b")
            let status = issue["state"]
            
            if status as! String == "open" {
                cell.AllImage.image = openImage
            }else{
                cell.AllImage.image = closeImage
            }
            
        }else{
            NSLog("all-3rd method is nil.")
        }
        
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "DetailViewTwoSeg"{
            if let destination = segue.destinationViewController as? DetailTwoViewController{
                let path = tableView.indexPathForSelectedRow
                destination.issue = self.issues![(path?.item)!]
                
                //destination.viaSegDateLabel = (cell?.textLabel.text)!
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
