//
//  MemesManager.swift
//  MemeMe
//
//  Created by Gregory White on 10/23/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

// MARK: -
// MARK: -

final class MemesManager {
    
    // MARK: - Variables

    static let shared = MemesManager()

    private var memes: [Meme]

    // MARK: - Initializers

    private init() { memes = [Meme]() }
    
}



// MARK: -
// MARK: - API

extension MemesManager {

    // MARK: - Variables

    var count: Int { return memes.count }

    // MARK: - Methods

    func add(_ meme: Meme)                     { memes.append(meme) }
    func deleteMeme(at indexPath: IndexPath)   { memes.remove(at: indexPath.row) }
    func meme(at indexPath: IndexPath) -> Meme { return memes[indexPath.row] }

    func moveMeme(from indexPath1: IndexPath, to indexPath2: IndexPath)
    {
        let meme = memes.remove(at: indexPath1.row)
        memes.insert(meme, at: indexPath2.row)
    }

}
