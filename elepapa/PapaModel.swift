//
//  PapaListModel.swift
//  elepapa.ios
//
//  Created by Yuming Cao on 11/26/14.
//  Copyright (c) 2014 papa. All rights reserved.
//

import Foundation

class PapaModel: NSObject, Printable {
    let id: Int
    let title: String
    var content: String?
    let imageURL: String?
    
    override var description: String {
        return title
    }
    
    init(id: Int, title: String, imageURL: String?) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
    }
}