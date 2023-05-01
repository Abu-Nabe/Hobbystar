//
//  UserData.swift
//  Zinging
//
//  Created by Abu Nabe on 14/1/21.
//

import UIKit

struct UserData
{
    var image: String
    var text: String
    var Activity: Any
    var id : String
}

struct UserData1
{
    var image: String
    var text: String
    var Activity: Any
    var id : String
    var timeAgo = Date().timeIntervalSince1970
}
