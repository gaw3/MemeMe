//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Gregory White on 10/23/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

final class MemeDetailViewController: UIViewController {

	// MARK: - Internal Constants

	struct UI {
		static let StoryboardID = "MemeDetailViewController"
	}

	// MARK: - Internal Stored Variables

	var memeToDisplay: Meme!
	
	// MARK: - Private Stored Variables

	fileprivate var memeDetailView: UIImageView!

	// MARK: - View Events

	override func viewDidLoad() {
		super.viewDidLoad()

		memeDetailView = UIImageView()
		memeDetailView.contentMode = .scaleAspectFit
		memeDetailView.isHidden      = false

		view.addSubview(memeDetailView)
	}

	// MARK: - View Layout

	override func updateViewConstraints() {
		super.updateViewConstraints()

		resetMemeDetailView()
	}

	// MARK: - IB Actions

	@IBAction func editButtonWasTapped(_ sender: UIBarButtonItem) {
		let memeEditorNavCtlr = storyboard?.instantiateViewController(withIdentifier: StoryboardID.MemeEditorNavCtlr)
										as! UINavigationController
      let memeEditorVC      = memeEditorNavCtlr.viewControllers[0] as! MemeEditorViewController

		memeEditorVC.memeToEdit = memeToDisplay
		present(memeEditorNavCtlr, animated: true, completion: nil)
	}

	// MARK: - Private

	fileprivate func resetMemeDetailView() {
		memeDetailView.frame = view.bounds

		let widthScale         = view.frame.size.width / memeToDisplay.memedImage.size.width
		let heightScale        = view.frame.size.height / memeToDisplay.memedImage.size.height
		let scaleToUse         = min(widthScale, heightScale)
		let widthAfterScaling  = memeToDisplay.memedImage.size.width * scaleToUse
		let heightAfterScaling = memeToDisplay.memedImage.size.height * scaleToUse

		memeDetailView.image        = memeToDisplay.memedImage
		memeDetailView.frame.size   = CGSize(width: widthAfterScaling, height: heightAfterScaling)
		memeDetailView.frame.origin = CGPoint(x: (view.frame.size.width - widthAfterScaling) / 2,
																y: (view.frame.size.height - heightAfterScaling) / 2)
	}

}
