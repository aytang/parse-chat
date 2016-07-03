//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Nicholas Aiwazian on 2/3/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chatTextField: UITextField!
    
    var messages: [PFObject]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure TableView
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        
        // Start Timer
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(onTimerFired), userInfo: nil, repeats: true)
    }
    
    func onTimerFired() {
        print("Timer fired")
        self.reloadMessages()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages == nil ? 0 : self.messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let chatCell = tableView.dequeueReusableCellWithIdentifier("chatCell") as! ChatTableViewCell
        let message = self.messages[indexPath.row]
        if let user = message["user"] as? PFUser {
            chatCell.nameLabel.text = user["username"] as? String
            chatCell.nameLabel.hidden = false
        } else {
            chatCell.nameLabel.text = ""
            chatCell.nameLabel.hidden = true
        }
        
        chatCell.messageLabel.text = message["text"] as? String
        return chatCell
    }
    
    func reloadMessages() {
        let query = PFQuery(className: "Message")
        query.orderByDescending("createdAt")
        query.includeKey("user")
        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                print("Error: \(error.userInfo)")
            } else {
                if let results = results {
                    print("Successfully retrieved \(results.count) messages")
                    self.messages = results
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.submitMessageToParse()
        return true
    }
    
    @IBAction func sendButtonTapped(sender: UIButton) {
        self.submitMessageToParse()
    }
    
    func submitMessageToParse() {
        let currentUser = PFUser.currentUser()
        let newMessage = PFObject(className: "Message")
        newMessage["user"] = currentUser
        newMessage["text"] = self.chatTextField.text!
        newMessage.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Message saved successfully")
            } else {
                print("Error saving message: \(error?.description)")
            }
        }
        
        self.chatTextField.text = ""
        self.chatTextField.resignFirstResponder()
        self.reloadMessages()
    }
}
