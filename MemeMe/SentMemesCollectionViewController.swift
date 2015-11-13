//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Gregory White on 10/19/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

private let CollectionCellReuseID = "SentMemesCollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController {

	// MARK: - IB Outlets

	@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

	// MARK: - View Events

	override func viewDidLoad() {
		super.viewDidLoad()

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "dataStoreWasModified:",
																					  name: MemesManagerMemeWasAddedNotification,
																					object: nil)

		collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: CollectionCellReuseID)
		collectionView?.backgroundColor = UIColor.whiteColor()

		let minimumSpacing: CGFloat = 3.0
		flowLayout.minimumInteritemSpacing = minimumSpacing
		flowLayout.minimumLineSpacing      = minimumSpacing
	}

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()

		let numOfCellsAcross: CGFloat = UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation) ? 3.0 : 5.0
		let itemWidth: CGFloat = (view.frame.size.width - (flowLayout.minimumInteritemSpacing * (numOfCellsAcross - 1))) / numOfCellsAcross

		flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth) // yes, a square on purpose
	}

	// MARK: - IB Actions

	@IBAction func addButtonWasTapped(sender: UIBarButtonItem) {
		let memeEditor = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorNavigationController") as! UINavigationController
		presentViewController(memeEditor, animated: true, completion: nil)
	}

	// MARK: - NSNotifications

	func dataStoreWasModified(notification: NSNotification) {
		collectionView?.reloadData()
	}
	
	// MARK: - UICollectionViewDataSource

	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let meme = MemesManager.sharedInstance.memeAtIndexPath(indexPath)
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CollectionCellReuseID, forIndexPath: indexPath)

      cell.backgroundView = UIImageView(image: meme.memedImage)

		return cell
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return MemesManager.sharedInstance.count()
	}

	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}

	// MARK: - UICollectionViewDelegate

	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let memeDetailVC = storyboard?.instantiateViewControllerWithIdentifier(MemeDetailVCStoryboardID) as! MemeDetailViewController
		memeDetailVC.memeToDisplay = MemesManager.sharedInstance.memeAtIndexPath(indexPath)

		navigationController?.pushViewController(memeDetailVC, animated: true)
	}

}
