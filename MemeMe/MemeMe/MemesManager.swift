//
//  MemesManager.swift
//  MemeMe
//
//  Created by Gregory White on 10/23/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

private let _sharedInstance = MemesManager()

final class MemesManager {

    class var shared: MemesManager {
        return _sharedInstance
    }

    fileprivate var memes: [Meme]

    fileprivate init() {
        memes = [Meme]()
    }
    
}



// MARK: - Class API

extension MemesManager {

    var count: Int {
        return memes.count
    }

    func add(_ newMeme: Meme) {
        memes.append(newMeme)
        NotificationCenter.default.post(name: NotificationName.MemeWasAdded, object: nil)
    }

    func deleteMemeAtIndexPath(_ indexPath: IndexPath) {
        memes.remove(at: indexPath.row)
        NotificationCenter.default.post(name: NotificationName.MemeWasDeleted, object: nil)
    }

    func memeAtIndexPath(_ indexPath: IndexPath) -> Meme {
        return memes[indexPath.row]
    }

    func moveMemeAtIndexPath(_ indexPath: IndexPath, toIndexPath: IndexPath)
    {
        let meme = memes.remove(at: indexPath.row)
        memes.insert(meme, at: toIndexPath.row)
        NotificationCenter.default.post(name: NotificationName.MemeWasMoved, object: nil)
    }

}
