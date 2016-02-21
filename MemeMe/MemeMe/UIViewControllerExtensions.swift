//
//  UIViewControllerExtensions.swift
//  MemeMe
//
//  Created by Gregory White on 2/21/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit

extension UIViewController {

	// MARK: - Internal Constants

	internal struct StoryboardID {
		static let MemeEditorNavCtlr = "MemeEditorNavigationController"
	}

	// MARK: - Internal Computed Variables

	internal var memesMgr: MemesManager {
		return MemesManager.sharedInstance
	}

}
