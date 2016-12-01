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

	class internal var sharedInstance: MemesManager {
		return _sharedInstance
	}

	// MARK: - Internal Constants

	internal struct Notification {
		static let MemeWasAdded   = "MemesManagerMemeWasAddedNotification"
		static let MemeWasDeleted = "MemesManagerMemeWadDeletedNotification"
		static let MemeWasMoved   = "MemesManagerMemeWasMovedNotification"
	}

	// MARK: - Private Stored Variables

	fileprivate var memes: [Meme]

	// MARK: - Internal Computed Variables

	internal var count: Int {
		return memes.count
	}

	// MARK: - API

	internal func add(_ newMeme: Meme) {
		memes.append(newMeme)
		postNotification(Notification.MemeWasAdded)
	}

	internal func deleteMemeAtIndexPath(_ indexPath: IndexPath) {
		memes.remove(at: indexPath.row)
		postNotification(Notification.MemeWasDeleted)
	}

	internal func memeAtIndexPath(_ indexPath: IndexPath) -> Meme {
		return memes[indexPath.row]
	}

	internal func moveMemeAtIndexPath(_ indexPath: IndexPath, toIndexPath: IndexPath)
	{
		let meme = memes.remove(at: indexPath.row)
		memes.insert(meme, at: toIndexPath.row)
		postNotification(Notification.MemeWasMoved)
	}

	// MARK: - Private

	fileprivate override init() {
		memes = [Meme]()
		super.init()
	}

	fileprivate func postNotification(_ name: String) {
		NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: name), object: nil)
	}
	
}
