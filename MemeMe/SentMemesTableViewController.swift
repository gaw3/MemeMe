//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Gregory White on 10/19/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {

	// MARK: - View Events

	override func viewDidLoad() {
		super.viewDidLoad()

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "dataStoreWasModified:", name: MemeAdded, object: nil)

		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false

		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem()
	}

	// MARK: - IB Actions

	@IBAction func addButtonWasTapped(sender: UIBarButtonItem) {
		let memeEditor = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorNavigationController") as! UINavigationController
		presentViewController(memeEditor, animated: true, completion: nil)
	}

	// MARK: - NSNotifications

	func dataStoreWasModified(notification: NSNotification) {
		tableView.reloadData()
	}

	// MARK: - UITableViewDataSource

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let meme = MemesManager.sharedInstance.memeAtIndexPath(indexPath)
		let cell = tableView.dequeueReusableCellWithIdentifier(SentMemesTableViewCellReuseID, forIndexPath: indexPath) as! SentMemesTableViewCell

		cell.topPhrase!.text   = meme.topPhrase
		cell.bottomPhrase.text = meme.bottomPhrase
		cell.memeView!.image   = meme.memedImage

		return cell
	}

	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			MemesManager.sharedInstance.removeAtIndexPath(indexPath)
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
		}

	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return MemesManager.sharedInstance.count()
	}

	// MARK: - UITableViewDelegate

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let memeDetailVC = storyboard!.instantiateViewControllerWithIdentifier(MemeDetailVCStoryboardID) as! MemeDetailViewController
		memeDetailVC.memeToDisplay = MemesManager.sharedInstance.memeAtIndexPath(indexPath)

		navigationController!.pushViewController(memeDetailVC, animated: true)
	}

}
