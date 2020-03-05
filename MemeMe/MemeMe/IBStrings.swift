//
//  IBStrings.swift
//  MemeMe
//
//  Created by Gregory White on 12/1/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

enum IB {

    enum ReuseID {
        static let sentMemesCollectionViewCell = "SentMemesCollectionViewCell"
        static let sentMemesTableViewCell      = "SentMemesTableViewCell"
    }
    
    enum SegueID {
        static let collectionToMemeEditor = "SegueFromCollectionViewToMemeEditor"
        static let tableToMemeEditor      = "SegueFromTableViewToMemeEditor"
        static let detailToMemeEditor     = "SegueFromMemeDetailToMemeEditor"
    }

    enum StoryboardID {
        static let memeDetailViewController       = "MemeDetailViewController"
        static let memeEditorNavigationController = "MemeEditorNavigationController"
    }

}
