//
//  Meme.swift
//  MemeMe
//
//  Created by Felix Christmann-Jacoby on 12.06.15.
//  Copyright (c) 2015 Felix Christmann-Jacoby. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    var textTop: String = ""
    var textBottom: String = ""
    var image: UIImage?
    var memedImage: UIImage?
    
    init (textTop:String, textBottom: String, image: UIImage, memedImage: UIImage) {
        self.textTop = textTop
        self.textBottom = textBottom
        self.image = image
        self.memedImage = memedImage
    }
}