//
//  Ad.swift
//  Zinging
//
//  Created by Abu Nabe on 20/2/21.
//

import UIKit
import GoogleMobileAds

class Ad {
    var postimage: String
    var publisher: String
    var timestring: String
    var timestamp = Date().timeIntervalSince1970

    // You can add timestamp here also if you wish
    init(postimage: String, publisher: String, timestring: String, timestamp: Double) {
        self.postimage = postimage
        self.publisher = publisher
        self.timestring = timestring
        self.timestamp = Date().timeIntervalSince1970
    }
}

class PostDataAd: Ad {
    // Define some custom properties
}
class NativeAd: Ad {
    // Declare here your custom properties
    struct NativeAd
    {
        var nativeAds: [GADUnifiedNativeAd] = [GADUnifiedNativeAd]()
    }
}

//var array = [Ad]()

//let postdata = PostData()
//let nativead = NativeAd()
//
//    array.append(postdata)
//    array.append(nativead)

