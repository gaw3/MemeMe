//
//  SentMemesTableViewCell.swift
//  MemeMe
//
//  Created by Gregory White on 11/4/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

final class SentMemesTableViewCell: UITableViewCell {

    // for vertSizeClass = Regular && horizSizeClass = Compact
    // iPhone 6+ / 6s+ in Portrait
    // Remaining iPhones in Portrait & Landscape

    @IBOutlet weak var topPhrase:    UILabel!
    @IBOutlet weak var bottomPhrase: UILabel!
    @IBOutlet weak var memeView:     UIImageView!
}
