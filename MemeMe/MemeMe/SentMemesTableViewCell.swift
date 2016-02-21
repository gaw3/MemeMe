//
//  SentMemesTableViewCell.swift
//  MemeMe
//
//  Created by Gregory White on 11/4/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

final class SentMemesTableViewCell: UITableViewCell {

	// MARK: - Internal Constants

	internal struct UI {
		static let ReuseID = "SentMemesTableViewCell"
	}

   // for vertSizeClass = Regular && horizSizeClass = Compact
	// iPhone 6+ / 6s+ in Portrait
	// Remaining iPhones in Portrait & Landscape

	@IBOutlet weak var topPhraseRegularCompact:    UILabel!
	@IBOutlet weak var bottomPhraseRegularCompact: UILabel!
	@IBOutlet weak var memeViewRegularCompact:     UIImageView!

   // for vertSizeClass = Compact && horizSizeClass = Regular
	// iPhone 6+ / 6s+ in Landscape

	@IBOutlet weak var topPhraseCompactRegular:    UILabel!
	@IBOutlet weak var bottomPhraseCompactRegular: UILabel!
	@IBOutlet weak var memeViewCompactRegular:     UIImageView!
}
