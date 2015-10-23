//
//  MemesManager.swift
//  MemeMe
//
//  Created by Gregory White on 10/23/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import Foundation
import UIKit

private let _sharedInstance = MemesManager()

let MemeAdded = "MemeAddedToDataStore"

class MemesManager: NSObject {

	// MARK: - Class variables

	private var memes: [Meme]

	class var sharedInstance: MemesManager {
		return _sharedInstance
	}

	// MARK: - API

	func add(newMeme: Meme) {
		memes.append(newMeme)
		postNotification(MemeAdded)
	}

	func count() -> Int {
		return memes.count
	}

	func memeAtIndexPath(indexPath: NSIndexPath) -> Meme {
		return memes[indexPath.row]
	}

	func removeAtIndexPath(indexPath: NSIndexPath) {
		memes.removeAtIndex(indexPath.row)
	}

	// MARK: - Private

	private override init() {
		memes = [Meme]()
		super.init()
	}

	private func postNotification(name: String) {
		NSNotificationCenter.defaultCenter().postNotificationName(name, object: nil)
	}
	
}
