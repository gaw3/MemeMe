//
//  Meme.swift
//  MemeMe
//
//  Created by Gregory White on 10/9/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
	let originalImage: UIImage!
	let topPhrase: String!
	let bottomPhrase: String!
	let memedImage: UIImage!

	init(originalImage: UIImage, topPhrase: String, bottomPhrase: String, memedImage: UIImage) {
		self.originalImage = originalImage
		self.topPhrase = topPhrase
		self.bottomPhrase = bottomPhrase
		self.memedImage = memedImage
	}

}
