//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Gregory White on 10/19/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

private let CollectionCellReuseID = "SentMemeCollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController {

	// MARK: - IB Outlets

	@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

	// MARK: - View Events

	override func viewDidLoad() {
		super.viewDidLoad()

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "dataStoreWasModified:", name: MemeAdded, object: nil)
		collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: CollectionCellReuseID)

		let minimumSpacing: CGFloat = 3.0
		flowLayout.minimumInteritemSpacing = minimumSpacing
		flowLayout.minimumLineSpacing = minimumSpacing

		let itemWidth = (view.frame.size.width - (minimumSpacing * 2.0)) / 3.0
		flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth) // yes, a square on purpose

		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false

	}

	// MARK: - IB Actions

	@IBAction func addButtonWasTapped(sender: UIBarButtonItem) {
		let memeEditor = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorNavigationController") as! UINavigationController
		presentViewController(memeEditor, animated: true, completion: nil)
	}

	// MARK: - NSNotifications

	func dataStoreWasModified(notification: NSNotification) {
		collectionView!.reloadData()
	}
	
	// MARK: - UICollectionViewDataSource

	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let meme = MemesManager.sharedInstance.memeAtIndexPath(indexPath)
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CollectionCellReuseID, forIndexPath: indexPath)
      let imageView = UIImageView(image: meme.memedImage)

      cell.backgroundView = imageView

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
		let memeDetailVC = storyboard!.instantiateViewControllerWithIdentifier(MemeDetailVCStoryboardID) as! MemeDetailViewController
		memeDetailVC.memeToDisplay = MemesManager.sharedInstance.memeAtIndexPath(indexPath)

		navigationController!.pushViewController(memeDetailVC, animated: true)
	}

}
