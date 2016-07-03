//
//  Message.swift
//  ParseChat
//
//  Created by Sumeet Shendrikar on 6/22/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import Foundation
import Parse

class Message {
    static let ParseClassName = "Message_fbuJuly2016"
    
    static let AuthorKey = "user"
    static let TextKey = "text"
    static let MediaKey = "media"
    
    private var _parseObject : PFObject!
    
    init(msg: String?){
        if let msg = msg {
            self.text = msg
        }else{
            self.text = ""
        }
    }
    
    init(object: PFObject?) {
        _parseObject = object
    }
    
    convenience init() {
        self.init(object: PFObject(className: Message.ParseClassName))
    }
    
    class func messagesFromArray( objectArray: [PFObject]) -> [Message] {
        var outputArray : [Message] = []
        for obj in objectArray {
            let message = Message(object: obj)
            outputArray.append(message)
        }
        
        return outputArray
    }
    
    class func simplerMessagesFromArray( objectArray: [PFObject]) -> [Message] {
        return objectArray.map( { Message(object: $0) } )
    }
    
    var author : PFUser? {
        get {
            return _parseObject[Message.AuthorKey] as? PFUser
        }
        set(arg) {
            _parseObject[Message.AuthorKey] = arg
        }
    }
    
    var authorName : String? {
        get {
            return self.author?.username
        }
    }

    
    var media : PFFile? {
        get {
            return _parseObject[Message.MediaKey] as? PFFile
        }
        set(arg) {
            _parseObject[Message.MediaKey] = arg
        }
    }
    
    var text : String? {
        get {
            return _parseObject[Message.TextKey] as? String
        }
        set(arg) {
            _parseObject[Message.TextKey] = arg
        }
    }
    
    
    func post(completion: ((error: NSError?) -> Void)?) {
        if _parseObject[Message.AuthorKey] == nil {
            _parseObject[Message.AuthorKey] = PFUser.currentUser()
        }

        _parseObject.saveInBackgroundWithBlock{ (success: Bool, error: NSError?) in
            if let completion = completion {
                if success {
                    completion(error:nil)
                }else{
                    completion(error:error)
                }
            }
        }
    }
    
    
    class func query(completion: (messages: [Message]?, error: NSError?) -> Void) {
        let query = PFQuery(className: Message.ParseClassName)
        query.orderByDescending("createdAt")
        query.includeKey(Message.AuthorKey)
        
        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                completion(messages: nil, error:error)
            } else {
                if let results = results {
                    let messages = Message.messagesFromArray(results)
                    completion(messages: messages, error: error)
                }
            }
        }
    }

}
