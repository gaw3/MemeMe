//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Gregory White on 10/19/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

final internal class SentMemesCollectionViewController: UICollectionViewController {

	// MARK: - Private Constants

	private struct Layout {
		static let NumberOfCellsAcrossInPortrait:  CGFloat = 3.0
		static let NumberOfCellsAcrossInLandscape: CGFloat = 5.0
		static let MinimumInteritemSpacing:        CGFloat = 3.0
	}

	private struct SEL {
		static let MemesWereModified: Selector = "memesWereModified:"
	}

	private struct UI {
		static let CollectionCellReuseID = "SentMemesCollectionViewCell"
	}

	// MARK: - IB Outlets

	@IBOutlet weak internal var flowLayout: UICollectionViewFlowLayout!

	// MARK: - View Events

	override internal func viewDidLoad() {
		super.viewDidLoad()

		NSNotificationCenter.defaultCenter().addObserver(self, selector: SEL.MemesWereModified,
																					  name: MemesManager.Notification.MemeWasAdded,
																					object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: SEL.MemesWereModified,
																					  name: MemesManager.Notification.MemeWasDeleted,
																					object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: SEL.MemesWereModified,
																					  name: MemesManager.Notification.MemeWasMoved,
																					object: nil)

		collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: UI.CollectionCellReuseID)
		collectionView?.backgroundColor = UIColor.whiteColor()

		flowLayout.minimumInteritemSpacing = Layout.MinimumInteritemSpacing
		flowLayout.minimumLineSpacing      = Layout.MinimumInteritemSpacing
	}

	override internal func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()

		let numOfCellsAcross: CGFloat = UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)
			                           ? Layout.NumberOfCellsAcrossInPortrait : Layout.NumberOfCellsAcrossInLandscape
		let itemWidth: CGFloat = (view.frame.size.width - (flowLayout.minimumInteritemSpacing * (numOfCellsAcross - 1))) / numOfCellsAcross

		flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth) // yes, a square on purpose
	}

	// MARK: - IB Actions

	@IBAction internal func addButtonWasTapped(sender: UIBarButtonItem) {
		let memeEditor = storyboard?.instantiateViewControllerWithIdentifier(StoryboardID.MemeEditorNavCtlr) as! UINavigationController
		presentViewController(memeEditor, animated: true, completion: nil)
	}

	// MARK: - NSNotifications

	internal func memesWereModified(notification: NSNotification) {
		assert(notification.name == MemesManager.Notification.MemeWasAdded ||
			    notification.name == MemesManager.Notification.MemeWasDeleted ||
			    notification.name == MemesManager.Notification.MemeWasMoved, "received unexpected NSNotification")

		collectionView?.reloadData()
	}

	// MARK: - UICollectionViewDataSource

	override internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		assert(collectionView == self.collectionView, "Unexpected collection view reqesting cell of item at index path")

		let meme = MemesManager.sharedInstance.memeAtIndexPath(indexPath)
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(UI.CollectionCellReuseID, forIndexPath: indexPath)

      cell.backgroundView = UIImageView(image: meme.memedImage)

		return cell
	}
	
	override internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		assert(collectionView == self.collectionView, "Unexpected collection view reqesting number of items in section")

		return MemesManager.sharedInstance.count()
	}

	override internal func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		assert(collectionView == self.collectionView, "Unexpected collection view reqesting number of sections in view")

		return 1
	}

	// MARK: - UICollectionViewDelegate

	override internal func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		assert(collectionView == self.collectionView, "Unexpected collection view selected an item")

		let memeDetailVC = storyboard?.instantiateViewControllerWithIdentifier(MemeDetailViewController.UI.StoryboardID) as! MemeDetailViewController
		memeDetailVC.memeToDisplay = MemesManager.sharedInstance.memeAtIndexPath(indexPath)

		navigationController?.pushViewController(memeDetailVC, animated: true)
	}

}
