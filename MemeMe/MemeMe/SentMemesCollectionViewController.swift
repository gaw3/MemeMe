//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Gregory White on 10/19/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

private let CollectionCellReuseID = "SentMemesCollectionViewCell"

private let NumberOfCellsAcrossInPortrait:  CGFloat = 3.0
private let NumberOfCellsAcrossInLandscape: CGFloat = 5.0
private let MinimumInteritemSpacing:        CGFloat = 3.0

class SentMemesCollectionViewController: UICollectionViewController {

	// MARK: - IB Outlets

	@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

	// MARK: - View Events

	override func viewDidLoad() {
		super.viewDidLoad()

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "memesWereModified:",
																					  name: MemesManagerMemeWasAddedNotification,
																					object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "memesWereModified:",
																					  name: MemesManagerMemeWasDeletedNotification,
																					object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "memesWereModified:",
																					  name: MemesManagerMemeWasMovedNotification,
																					object: nil)

		collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: CollectionCellReuseID)
		collectionView?.backgroundColor = UIColor.whiteColor()

		flowLayout.minimumInteritemSpacing = MinimumInteritemSpacing
		flowLayout.minimumLineSpacing      = MinimumInteritemSpacing
	}

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()

		let numOfCellsAcross: CGFloat = UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)
			                           ? NumberOfCellsAcrossInPortrait : NumberOfCellsAcrossInLandscape
		let itemWidth: CGFloat = (view.frame.size.width - (flowLayout.minimumInteritemSpacing * (numOfCellsAcross - 1))) / numOfCellsAcross

		flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth) // yes, a square on purpose
	}

	// MARK: - IB Actions

	@IBAction func addButtonWasTapped(sender: UIBarButtonItem) {
		let memeEditor = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorNavigationController") as! UINavigationController
		presentViewController(memeEditor, animated: true, completion: nil)
	}

	// MARK: - NSNotifications

	func memesWereModified(notification: NSNotification) {
		assert(notification.name == MemesManagerMemeWasAddedNotification ||
			    notification.name == MemesManagerMemeWasDeletedNotification ||
			    notification.name == MemesManagerMemeWasMovedNotification, "received unexpected NSNotification")

		collectionView?.reloadData()
	}

	// MARK: - UICollectionViewDataSource

	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		assert(collectionView == self.collectionView, "Unexpected collection view reqesting cell of item at index path")

		let meme = MemesManager.sharedInstance.memeAtIndexPath(indexPath)
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CollectionCellReuseID, forIndexPath: indexPath)

      cell.backgroundView = UIImageView(image: meme.memedImage)

		return cell
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		assert(collectionView == self.collectionView, "Unexpected collection view reqesting number of items in section")

		return MemesManager.sharedInstance.count()
	}

	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		assert(collectionView == self.collectionView, "Unexpected collection view reqesting number of sections in view")

		return 1
	}

	// MARK: - UICollectionViewDelegate

	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		assert(collectionView == self.collectionView, "Unexpected collection view selected an item")

		let memeDetailVC = storyboard?.instantiateViewControllerWithIdentifier(MemeDetailVCStoryboardID) as! MemeDetailViewController
		memeDetailVC.memeToDisplay = MemesManager.sharedInstance.memeAtIndexPath(indexPath)

		navigationController?.pushViewController(memeDetailVC, animated: true)
	}

}
