//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Gregory White on 10/23/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

let MemeDetailVCStoryboardID = "MemeDetailViewController"

class MemeDetailViewController: UIViewController {

	// MARK: - Class Variables

	var memeToDisplay: Meme!
	
	private var memeDetailView: UIImageView!

	// MARK: - View Events

	override func viewDidLoad() {
		super.viewDidLoad()

		memeDetailView = UIImageView(image: memeToDisplay.memedImage)
		memeDetailView.backgroundColor = UIColor.orangeColor()
		memeDetailView.contentMode     = .ScaleAspectFit
		memeDetailView.hidden          = false

		view.addSubview(memeDetailView)
	}

	override func viewDidLayoutSubviews() {
		memeDetailView.frame.origin = CGPointMake((view.frame.size.width - memeDetailView.frame.size.width) / 2,
																(view.frame.size.height - memeDetailView.frame.size.height) / 2)
	}

	// MARK: - IB Actions

	@IBAction func editButtonWasTapped(sender: UIBarButtonItem) {
		let memeEditorNavCtlr = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorNavigationController") as! UINavigationController
      let memeEditorVC      = memeEditorNavCtlr.viewControllers[0] as! MemeEditorViewController

		memeEditorVC.memeToEdit = memeToDisplay
		presentViewController(memeEditorNavCtlr, animated: true, completion: nil)
	}

}
