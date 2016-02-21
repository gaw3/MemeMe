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

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "memeWasAdded:",
																					  name: MemesManagerMemeWasAddedNotification,
																					object: nil)

		navigationItem.leftBarButtonItem = self.editButtonItem()
	}

	// MARK: - IB Actions

	@IBAction func addButtonWasTapped(sender: UIBarButtonItem) {
		let memeEditor = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorNavigationController") as! UINavigationController
		presentViewController(memeEditor, animated: true, completion: nil)
	}

	// MARK: - Environment Changes

	override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
		tableView.reloadData()
	}
	
	// MARK: - NSNotifications

	func memeWasAdded(notification: NSNotification) {
		assert(notification.name == MemesManagerMemeWasAddedNotification, "received unexpected NSNotification")

		tableView.reloadData()
	}

	// MARK: - UITableViewDataSource

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		assert(tableView == self.tableView, "Unexpected table view requesting number of sections in table view")
		
		return 1
	}

	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		assert(tableView == self.tableView, "Unexpected table view requesting cell can be edited")

		return true
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		assert(tableView == self.tableView, "Unexpected table view requesting cell for row at index path")

		let meme = MemesManager.sharedInstance.memeAtIndexPath(indexPath)
		let cell = tableView.dequeueReusableCellWithIdentifier(SentMemesTableViewCellReuseID, forIndexPath: indexPath) as! SentMemesTableViewCell

		cell.topPhraseRegularCompact!.text    = meme.topPhrase
		cell.bottomPhraseRegularCompact!.text = meme.bottomPhrase
		cell.memeViewRegularCompact!.image    = meme.memedImage

		if view.traitCollection.horizontalSizeClass == .Regular && view.traitCollection.verticalSizeClass == .Compact {
			cell.topPhraseCompactRegular!.text    = meme.topPhrase
			cell.bottomPhraseCompactRegular!.text = meme.bottomPhrase
			cell.memeViewCompactRegular!.image    = meme.memedImage
		}

		return cell
	}

	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		assert(tableView == self.tableView, "Unexpected table view committing editing style")

		if editingStyle == .Delete {
			MemesManager.sharedInstance.deleteMemeAtIndexPath(indexPath)
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
		}

	}

	override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
		assert(tableView == self.tableView, "Unexpected table view requesting edit actions")

		let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { (action, indexPath) -> Void in
			MemesManager.sharedInstance.deleteMemeAtIndexPath(indexPath)
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
			self.editing = false
		}

		let cancelAction = UITableViewRowAction(style: .Default, title: "Cancel") { (action, indexPath) -> Void in
			self.editing = false
		}

		cancelAction.backgroundColor = UIColor.blueColor()

		return [cancelAction, deleteAction]
	}
	
	override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
		assert(tableView == self.tableView, "Unexpected table view commanding move row")

		MemesManager.sharedInstance.moveMemeAtIndexPath(sourceIndexPath, toIndexPath: destinationIndexPath)
      tableView.moveRowAtIndexPath(sourceIndexPath, toIndexPath: destinationIndexPath)
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		assert(tableView == self.tableView, "Unexpected table view requesting number of rows in section")

		return MemesManager.sharedInstance.count()
	}

	// MARK: - UITableViewDelegate

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		assert(tableView == self.tableView, "Unexpected table view selected a row")

		let memeDetailVC = storyboard?.instantiateViewControllerWithIdentifier(MemeDetailVCStoryboardID) as! MemeDetailViewController
		memeDetailVC.memeToDisplay = MemesManager.sharedInstance.memeAtIndexPath(indexPath)

		navigationController?.pushViewController(memeDetailVC, animated: true)
	}

}
