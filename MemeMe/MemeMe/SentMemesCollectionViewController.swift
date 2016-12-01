//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Gregory White on 10/19/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import CoreGraphics
import Foundation
import UIKit

final internal class SentMemesCollectionViewController: UICollectionViewController {

	// MARK: - Private Constants

	fileprivate struct Layout {
		static let NumberOfCellsAcrossInPortrait:  CGFloat = 3.0
		static let NumberOfCellsAcrossInLandscape: CGFloat = 5.0
		static let MinimumInteritemSpacing:        CGFloat = 3.0
	}

	fileprivate struct SEL {
		static let MemesWereModified = #selector(memesWereModified(_:))
	}

	fileprivate struct UI {
		static let CollectionCellReuseID = "SentMemesCollectionViewCell"
	}

	// MARK: - IB Outlets

	@IBOutlet weak internal var flowLayout: UICollectionViewFlowLayout!

	// MARK: - View Events

	override internal func viewDidLoad() {
		super.viewDidLoad()

      addNotificationObservers()
		
		collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UI.CollectionCellReuseID)
		collectionView?.backgroundColor = UIColor.white

		flowLayout.minimumInteritemSpacing = Layout.MinimumInteritemSpacing
		flowLayout.minimumLineSpacing      = Layout.MinimumInteritemSpacing
	}

	// MARK: - View Layout

	override internal func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()

		let numOfCellsAcross: CGFloat = UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
			                           ? Layout.NumberOfCellsAcrossInPortrait : Layout.NumberOfCellsAcrossInLandscape
		let itemWidth: CGFloat = (view.frame.size.width - (flowLayout.minimumInteritemSpacing * (numOfCellsAcross - 1))) / numOfCellsAcross

		flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth) // yes, a square on purpose
	}

	// MARK: - IB Actions

	@IBAction internal func addButtonWasTapped(_ sender: UIBarButtonItem) {
		let memeEditor = storyboard?.instantiateViewController(withIdentifier: StoryboardID.MemeEditorNavCtlr) as! UINavigationController
		present(memeEditor, animated: true, completion: nil)
	}

	// MARK: - NSNotifications

	internal func memesWereModified(_ notification: Notification) {
		assert(notification.name.rawValue == MemesManager.Notification.MemeWasAdded ||
               notification.name.rawValue == MemesManager.Notification.MemeWasDeleted ||
			   notification.name.rawValue == MemesManager.Notification.MemeWasMoved, "received unexpected NSNotification")

		collectionView?.reloadData()
	}

	// MARK: - UICollectionViewDataSource

	override internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		assert(collectionView == self.collectionView, "Unexpected collection view reqesting cell of item at index path")

		let meme = memesMgr.memeAtIndexPath(indexPath)
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UI.CollectionCellReuseID, for: indexPath)

      cell.backgroundView = UIImageView(image: meme.memedImage)

		return cell
	}
	
	override internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		assert(collectionView == self.collectionView, "Unexpected collection view reqesting number of items in section")

		return memesMgr.count
	}

	override internal func numberOfSections(in collectionView: UICollectionView) -> Int {
		assert(collectionView == self.collectionView, "Unexpected collection view reqesting number of sections in view")

		return 1
	}

	// MARK: - UICollectionViewDelegate

	override internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		assert(collectionView == self.collectionView, "Unexpected collection view selected an item")

		let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: MemeDetailViewController.UI.StoryboardID) as! MemeDetailViewController
		memeDetailVC.memeToDisplay = memesMgr.memeAtIndexPath(indexPath)

		navigationController?.pushViewController(memeDetailVC, animated: true)
	}

	// MARK: - Private Helpers

	fileprivate func addNotificationObservers() {
		NotificationCenter.default.addObserver(self, selector: SEL.MemesWereModified,
																		           name: NSNotification.Name(rawValue: MemesManager.Notification.MemeWasAdded),
																					object: nil)
		NotificationCenter.default.addObserver(self, selector: SEL.MemesWereModified,
																				     name: NSNotification.Name(rawValue: MemesManager.Notification.MemeWasDeleted),
																					object: nil)
		NotificationCenter.default.addObserver(self, selector: SEL.MemesWereModified,
																				     name: NSNotification.Name(rawValue: MemesManager.Notification.MemeWasMoved),
																					object: nil)
	}

}
