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

    func add(_ meme: Meme) {
        memes.append(meme)
        NotificationCenter.default.post(name: NotificationName.MemeWasAdded, object: nil)
    }

    func deleteMeme(at indexPath: IndexPath) {
        memes.remove(at: indexPath.row)
        NotificationCenter.default.post(name: NotificationName.MemeWasDeleted, object: nil)
    }

    func meme(at indexPath: IndexPath) -> Meme {
        return memes[indexPath.row]
    }

    func moveMeme(from indexPath1: IndexPath, to indexPath2: IndexPath)
    {
        let meme = memes.remove(at: indexPath1.row)
        memes.insert(meme, at: indexPath2.row)
        NotificationCenter.default.post(name: NotificationName.MemeWasMoved, object: nil)
    }

}
