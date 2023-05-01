//
//  SubMessage.swift
//  Zinging
//
//  Created by Abu Nabe on 19/1/21.
//
import UIKit
import Firebase
import MessageKit

struct SubMessage {

    var message: String?
    var receiver: String
    var seen: Bool
    var sender: String
}

struct SubGather{
    var message: String?
    var receiver: String
    var seen: Bool
    var sender: String
    var username : String
}
