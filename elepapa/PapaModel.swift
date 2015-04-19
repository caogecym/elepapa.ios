//
//  PapaListModel.swift
//  elepapa
//
//  Created by Yuming Cao on 11/26/14.
//  Copyright (c) 2014 papa. All rights reserved.
//

import Foundation
import UIKit


public class Post: NSObject {
    public var author_name: String
    public var author_avatar_url: String
    public var content: String
    
    public init(author_name: String, author_avatar_url: String, content: String) {
        self.author_name = author_name
        self.author_avatar_url = author_avatar_url
        self.content = content
    }
}


public class PapaModel: NSObject, Printable {
    public let id: Int
    public let title: String
    public var author_name: String?
    public var imageURL: String?
    public var visited: Bool
    public var posts: [Post]
    
    override public var description: String {
        return title
    }
    
    public init(id: Int, title: String, imageURL: String?) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.visited = false
        self.posts = []
    }
    
    public func getText() -> String {
        if let encodedData = self.posts[0].content.dataUsingEncoding(NSUTF16StringEncoding) {
            let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            
            let attributedString = NSAttributedString(
                data: encodedData,
                options: attributedOptions,
                documentAttributes: nil,
                error: nil
            )
            
            if let str = attributedString?.string {
                return str.substringToIndex(advance(str.startIndex, min(40, countElements(str))))
            }
            else {
                return ""
            }
        }
        else {
            return ""
        }
    }
}