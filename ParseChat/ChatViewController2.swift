//
//  ChatViewController2.swift
//  ParseChat
//
//  Created by Nicholas Aiwazian on 2/3/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class ChatViewController2: UIViewController, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chatTextField: UITextField!
    
    var messages: [Message] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure TableView
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        
        self.tableView.reloadData()
        
        // Start Timer
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(onTimerFired), userInfo: nil, repeats: true)
    }
    
    func onTimerFired() {
        print("Timer fired")
        self.reloadMessages()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let chatCell = tableView.dequeueReusableCellWithIdentifier("chatCell") as! ChatTableViewCell
        chatCell.message = self.messages[indexPath.row]
        return chatCell
    }
    
    func reloadMessages() {
        Message.query{(messages: [Message]?, error: NSError?) -> Void in
            if let error = error {
                print("Error: \(error.userInfo)")
            } else {
                if let messages = messages {
                    print("Successfully retrieved \(messages.count) messages")
                    self.messages = messages
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
        let message = Message(msg: self.chatTextField?.text)
        message.post{ (error: NSError?) -> Void in
            if let error = error {
                print("Error saving message: \(error.description)")
            }else{
                print("Message saved successfully")
            }
        }
        
        self.chatTextField.text = ""
        self.chatTextField.resignFirstResponder()
        self.reloadMessages()
    }
}
