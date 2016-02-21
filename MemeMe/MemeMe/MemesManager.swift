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

final internal class MemesManager: NSObject {

	// MARK: - Internal Constants

	internal struct Notification {
		static let MemeWasAdded   = "MemesManagerMemeWasAddedNotification"
		static let MemeWasDeleted = "MemesManagerMemeWadDeletedNotification"
		static let MemeWasMoved   = "MemesManagerMemeWasMovedNotification"
	}

	// MARK: - Class variables

	private var memes: [Meme]

	class internal var sharedInstance: MemesManager {
		return _sharedInstance
	}

	// MARK: - API

	internal func add(newMeme: Meme) {
		memes.append(newMeme)
		postNotification(Notification.MemeWasAdded)
	}

	internal func count() -> Int {
		return memes.count
	}

	internal func deleteMemeAtIndexPath(indexPath: NSIndexPath) {
		memes.removeAtIndex(indexPath.row)
		postNotification(Notification.MemeWasDeleted)
	}

	internal func memeAtIndexPath(indexPath: NSIndexPath) -> Meme {
		return memes[indexPath.row]
	}

	internal func moveMemeAtIndexPath(indexPath: NSIndexPath, toIndexPath: NSIndexPath)
	{
		let meme = memes.removeAtIndex(indexPath.row)
		memes.insert(meme, atIndex: toIndexPath.row)
		postNotification(Notification.MemeWasMoved)
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
