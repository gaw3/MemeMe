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

		memeDetailView = UIImageView()
		memeDetailView.contentMode = .ScaleAspectFit
		memeDetailView.hidden      = false

		view.addSubview(memeDetailView)
	}

	// MARK: - View Layout

	override func updateViewConstraints() {
		super.updateViewConstraints()

		resetMemeDetailView()
	}

	// MARK: - IB Actions

	@IBAction func editButtonWasTapped(sender: UIBarButtonItem) {
		let memeEditorNavCtlr = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorNavigationController") as! UINavigationController
      let memeEditorVC      = memeEditorNavCtlr.viewControllers[0] as! MemeEditorViewController

		memeEditorVC.memeToEdit = memeToDisplay
		presentViewController(memeEditorNavCtlr, animated: true, completion: nil)
	}

	private func resetMemeDetailView() {
		memeDetailView.frame = view.bounds

		let widthScale         = view.frame.size.width / memeToDisplay.memedImage.size.width
		let heightScale        = view.frame.size.height / memeToDisplay.memedImage.size.height
		let scaleToUse         = min(widthScale, heightScale)
		let widthAfterScaling  = memeToDisplay.memedImage.size.width * scaleToUse
		let heightAfterScaling = memeToDisplay.memedImage.size.height * scaleToUse

		memeDetailView.image        = memeToDisplay.memedImage
		memeDetailView.frame.size   = CGSizeMake(widthAfterScaling, heightAfterScaling)
		memeDetailView.frame.origin = CGPointMake((view.frame.size.width - widthAfterScaling) / 2,
																(view.frame.size.height - heightAfterScaling) / 2)
	}

}
