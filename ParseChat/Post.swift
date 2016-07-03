//
//  Post.swift
//  ParseChat
//
//  Created by Sumeet Shendrikar on 6/21/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    
    static let MediaKey = "media"
    static let AuthorKey = "author"
    static let CaptionKey = "caption"
    static let LikesCountKey = "likesCount"
    static let CommentsCountKey = "commentsCount"
    
    
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
        
        // Add relevant fields to the object
        post[Post.MediaKey] = getPFFileFromImage(image) // PFFile column type
        post[Post.AuthorKey] = PFUser.currentUser() // Pointer column type that points to PFUser
        post[Post.CaptionKey] = caption
        post[Post.LikesCountKey] = 0
        post[Post.CommentsCountKey] = 0
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackgroundWithBlock(completion)
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    
    func doSomethingWithPost( post : PFObject?) {
        if let post = post {
            post[Post.MediaKey] = "foo"
        }
    }
}




class Post2 : NSObject {
    static let MediaKey = "media"
    static let AuthorKey = "author"
    static let CaptionKey = "caption"
    static let LikesCountKey = "likesCount"
    static let CommentsCountKey = "commentsCount"
    
    private var parseObject: PFObject!
    
    private init(object : PFObject) {
        super.init()
        parseObject = object
    }
    
    convenience override init() {
        self.init( object: PFObject() )
    }
    
    
    class func postsFromArray( objectArray: [PFObject]) -> [Post2] {
        var outputArray : [Post2] = []
        for obj in objectArray {
            let post2 = Post2(object: obj)
            outputArray.append(post2)
        }
        
        return outputArray
    }
    
    class func simplerPostsFromArray( objectArray: [PFObject]) -> [Post2] {
        return objectArray.map( { Post2(object: $0) } )
    }
    
    var media : PFFile? {
        get {
            return parseObject[Post2.MediaKey] as? PFFile
        }
        set(arg) {
            parseObject[Post2.MediaKey] = arg
        }
    }
    
    var author : String? {
        get {
            return parseObject[Post2.AuthorKey] as? String
        }
        set(arg) {
            parseObject[Post2.AuthorKey] = arg
        }
    }
    
    var caption : String? {
        get {
            return parseObject[Post2.CaptionKey] as? String
        }
        set(arg) {
            parseObject[Post2.CaptionKey] = arg
        }
    }
    
    var likesCount : Int? {
        get {
            return parseObject[Post2.LikesCountKey] as? Int
        }
        set(arg) {
            parseObject[Post2.LikesCountKey] = arg
        }
    }
    
    var commentsCount : Int? {
        get {
            return parseObject[Post2.CommentsCountKey] as? Int
        }
        set(arg) {
            parseObject[Post2.CommentsCountKey] = arg
        }
    }
    
    
    func save(withCompletion completion : PFBooleanResultBlock?) {
        parseObject.saveInBackgroundWithBlock(completion)
    }
    
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
        
        // Add relevant fields to the object
        post[Post.MediaKey] = getPFFileFromImage(image) // PFFile column type
        post[Post.AuthorKey] = PFUser.currentUser() // Pointer column type that points to PFUser
        post[Post.CaptionKey] = caption
        post[Post.LikesCountKey] = 0
        post[Post.CommentsCountKey] = 0
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackgroundWithBlock(completion)
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}

class Foo {
    func foo(post : Post2) {
        // get author
        print("\(post.author)")
        // get caption
        print("\(post.caption)")
        
        // set like count
        post.likesCount = 5
    }
}


