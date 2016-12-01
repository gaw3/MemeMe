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

final class MemesManager: NSObject {

    class var sharedInstance: MemesManager {
        return _sharedInstance
    }

    // MARK: - Internal Constants

    struct Notification {
        static let MemeWasAdded   = "MemesManagerMemeWasAddedNotification"
        static let MemeWasDeleted = "MemesManagerMemeWadDeletedNotification"
        static let MemeWasMoved   = "MemesManagerMemeWasMovedNotification"
    }

    // MARK: - Private Stored Variables

    fileprivate var memes: [Meme]

    // MARK: - Internal Computed Variables

    var count: Int {
        return memes.count
    }

    // MARK: - API

    func add(_ newMeme: Meme) {
        memes.append(newMeme)
        postNotification(Notification.MemeWasAdded)
    }

    func deleteMemeAtIndexPath(_ indexPath: IndexPath) {
        memes.remove(at: indexPath.row)
        postNotification(Notification.MemeWasDeleted)
    }

    func memeAtIndexPath(_ indexPath: IndexPath) -> Meme {
        return memes[indexPath.row]
    }

    func moveMemeAtIndexPath(_ indexPath: IndexPath, toIndexPath: IndexPath)
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
