//
//  SentMemesTableViewCell.swift
//  MemeMe
//
//  Created by Gregory White on 11/4/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

final internal class SentMemesTableViewCell: UITableViewCell {

    // MARK: - Internal Constants

    internal struct UI {
        static let ReuseID = "SentMemesTableViewCell"
    }

    // for vertSizeClass = Regular && horizSizeClass = Compact
    // iPhone 6+ / 6s+ in Portrait
    // Remaining iPhones in Portrait & Landscape

    @IBOutlet weak internal var topPhraseRegularCompact:    UILabel!
    @IBOutlet weak internal var bottomPhraseRegularCompact: UILabel!
    @IBOutlet weak internal var memeViewRegularCompact:     UIImageView!

    // for vertSizeClass = Compact && horizSizeClass = Regular
    // iPhone 6+ / 6s+ in Landscape

    @IBOutlet weak internal var topPhraseCompactRegular:    UILabel!
    @IBOutlet weak internal var bottomPhraseCompactRegular: UILabel!
    @IBOutlet weak internal var memeViewCompactRegular:     UIImageView!
}
