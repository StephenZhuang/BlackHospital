//
//  AboutViewController.swift
//  BlackHospital
//
//  Created by Stephen Zhuang on 16/8/9.
//  Copyright © 2016年 StephenZhuang. All rights reserved.
//

import UIKit
import MessageUI
import VTAcknowledgementsViewController

class AboutViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "作品相关"
        let view = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = view
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell")
            var title: String = ""
            var content: String = ""
            switch indexPath.row {
            case 0:
                title = "数据来源"
                content = "凤凰网"
            case 1:
                title = "美术"
                content = "Barachiel"
            default:
                title = "策划"
                content = "Stephen Zhuang"
            }
            cell?.textLabel?.text = title
            cell?.detailTextLabel?.text = content
            return cell!
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("action")
            if indexPath.section == 1 {
                cell?.textLabel?.text = "给作者提建议"
            } else {
                cell?.textLabel?.text = "感谢"
            }
            return cell!
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 1:
            if MFMailComposeViewController.canSendMail() {
                sendEmail()
            } else {
                let alert = UIAlertController(title: "您的邮箱没有设置", message: "请先去设置", preferredStyle: .Alert)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        case 2:
            let vc = VTAcknowledgementsViewController(fileNamed: "Pods-BlackHospital-acknowledgements")
            vc?.headerText = "感谢开源社区的贡献"
            self.navigationController?.pushViewController(vc!, animated: true)
            
        default:
            break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func sendEmail() -> Void {
        let mailCompose = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setSubject("【黑心医院】意见反馈")
        mailCompose.setToRecipients(["379128008@qq.com"])
        self.presentViewController(mailCompose, animated: true, completion: nil)
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
