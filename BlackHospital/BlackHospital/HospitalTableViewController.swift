//
//  HospitalTableViewController.swift
//  BlackHospital
//
//  Created by Stephen Zhuang on 16/8/8.
//  Copyright © 2016年 StephenZhuang. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class HospitalTableViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

    var hospitals: Results<Hospital>!
    var searchResults = Array<Hospital>()
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        self.tableView.tableHeaderView = searchController.searchBar
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
        if searchController.active {
            return searchResults.count
        } else {
            return hospitals.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        var hospital: Hospital?
        if searchController.active {
            hospital = searchResults[indexPath.row]
        } else {
            hospital = hospitals[indexPath.row]
        }
        cell.textLabel?.text = hospital?.name;
        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var hospital: Hospital?
        if searchController.active {
            hospital = searchResults[indexPath.row]
        } else {
            hospital = hospitals[indexPath.row]
        }
        let image = UIImage(named: "60")
        let url = NSURL(string: "http://finance.ifeng.com/a/20160504/14362042_0.shtml")
        let string = ("凤凰网曝光"+(hospital?.name)!)+"属于莆田系医院，小伙伴们千万不要去！"
        let activityController = UIActivityViewController(activityItems: [image! ,url!,string], applicationActivities: nil)
        self.presentViewController(activityController, animated: true, completion: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    //MARK: searchbar delegate
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//            //需要长时间处理的代码
//            let arr = NSMutableArray()
//            for hospital in self.hospitals {
//                if (hospital.name as NSString).containsString(searchText) {
//                    arr.addObject(hospital)
//                }
//            }
//            dispatch_async(dispatch_get_main_queue(), {
//                //需要主线程执行的代码
//                self.searchResults = arr
//            })
//        })
//        print(searchText)
//    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        
        var arr = Array<Hospital>()
        for hospital in self.hospitals {
            if (hospital.name as NSString).containsString(searchText!) {
                arr.append(hospital)
            }
        }
        searchResults = arr
        self.tableView.reloadData()
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
