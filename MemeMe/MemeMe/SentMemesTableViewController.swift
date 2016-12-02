//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Gregory White on 10/19/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import Foundation
import UIKit

final class SentMemesTableViewController: UITableViewController {

    // MARK: - Private Constants

    fileprivate struct ActionTitle {
        static let Cancel = "Cancel"
        static let Delete = "Delete"
    }

    fileprivate struct SEL {
        static let MemeWasAdded = #selector(memeWasAdded(_:))
    }

    // MARK: - View Events

    override func viewDidLoad() {
        super.viewDidLoad()

        addNotificationObservers()
        navigationItem.leftBarButtonItem = self.editButtonItem
    }

    // MARK: - IB Actions

    @IBAction func addButtonWasTapped(_ sender: UIBarButtonItem) {
        let memeEditor = storyboard?.instantiateViewController(withIdentifier: StoryboardID.MemeEditorNavCtlr) as! UINavigationController
        present(memeEditor, animated: true, completion: nil)
    }

    // MARK: - Environment Changes

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        tableView.reloadData()
    }

    // MARK: - NSNotifications

    internal func memeWasAdded(_ notification: Notification) {
        assert(notification.name == NotificationName.MemeWasAdded, "received unexpected Notification")

        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        assert(tableView == self.tableView, "Unexpected table view requesting number of sections in table view")

        return 1
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        assert(tableView == self.tableView, "Unexpected table view requesting cell can be edited")

        return true
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assert(tableView == self.tableView, "Unexpected table view requesting cell for row at index path")

        let meme = MemesManager.shared.memeAtIndexPath(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: SentMemesTableViewCell.UI.ReuseID, for: indexPath) as! SentMemesTableViewCell

        cell.topPhraseRegularCompact!.text    = meme.topPhrase
        cell.bottomPhraseRegularCompact!.text = meme.bottomPhrase
        cell.memeViewRegularCompact!.image    = meme.memedImage

        if view.traitCollection.horizontalSizeClass == .regular && view.traitCollection.verticalSizeClass == .compact {
            cell.topPhraseCompactRegular!.text    = meme.topPhrase
            cell.bottomPhraseCompactRegular!.text = meme.bottomPhrase
            cell.memeViewCompactRegular!.image    = meme.memedImage
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        assert(tableView == self.tableView, "Unexpected table view committing editing style")

        if editingStyle == .delete {
            MemesManager.shared.deleteMemeAtIndexPath(indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        assert(tableView == self.tableView, "Unexpected table view requesting edit actions")

        let deleteAction = UITableViewRowAction(style: .default, title: ActionTitle.Delete) { (action, indexPath) -> Void in
            MemesManager.shared.deleteMemeAtIndexPath(indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.isEditing = false
        }

        let cancelAction = UITableViewRowAction(style: .default, title: ActionTitle.Cancel) { (action, indexPath) -> Void in
            self.isEditing = false
        }

        cancelAction.backgroundColor = UIColor.blue

        return [cancelAction, deleteAction]
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        assert(tableView == self.tableView, "Unexpected table view commanding move row")

        MemesManager.shared.moveMemeAtIndexPath(sourceIndexPath, toIndexPath: destinationIndexPath)
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(tableView == self.tableView, "Unexpected table view requesting number of rows in section")

        return MemesManager.shared.count
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        assert(tableView == self.tableView, "Unexpected table view selected a row")

        let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: IB.StoryboardID.MemeDetailViewController) as! MemeDetailViewController
        memeDetailVC.memeToDisplay = MemesManager.shared.memeAtIndexPath(indexPath)

        navigationController?.pushViewController(memeDetailVC, animated: true)
    }

    fileprivate func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: SEL.MemeWasAdded, name: NotificationName.MemeWasAdded, object: nil)
    }
    
}
