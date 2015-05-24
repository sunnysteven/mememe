//
//  Meme.swift
//  MemeMe
//
//  Created by Steven on 19/05/2015.
//  Copyright (c) 2015 Horsemen. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memeImage: UIImage
    
    init( topText: String, bottomText: String, originalImage: UIImage, memeImage: UIImage ) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memeImage = memeImage
    }
}
