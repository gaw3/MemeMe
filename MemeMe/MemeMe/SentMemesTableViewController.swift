//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Gregory White on 10/19/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import Foundation
import UIKit

// MARK: -
// MARK: -

final class SentMemesTableViewController: UITableViewController {

    // MARK: - IB Outlets

    @IBOutlet weak var addButton: UIBarButtonItem!
    
    // MARK: - IB Actions

    @IBAction func barButtonWasTapped(_ barButtonItem: UIBarButtonItem) {

        switch barButtonItem {
        case addButton: performSegue(withIdentifier: IB.SegueID.tableToMemeEditor, sender: self)
        default:
            assertionFailure()
            log.error("Received event from unknown bar button item = \(barButtonItem)")
        }

    }

    // MARK: - View Events

    override func viewDidLoad() {
        super.viewDidLoad()
        logViewDidLoad()

        navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logViewWillAppear()
        tableView.reloadData()
    }
    
}



// MARK: -
// MARK: - Table View Data Source

extension SentMemesTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meme = MemesManager.shared.meme(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: IB.ReuseID.sentMemesTableViewCell, for: indexPath) as! SentMemesTableViewCell

        cell.topPhrase!.text    = meme.topPhrase
        cell.bottomPhrase!.text = meme.bottomPhrase
        cell.memeView!.image    = meme.memedImage

        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        log.verbose("trailing Swipe Actions Configuration For Row At \(indexPath)")
        
        let deleteAction = UIContextualAction(style: .destructive, title: ActionTitle.delete) {
            
            (contextualAction, view, actionPerformed) in
                log.verbose("delete action selected")
                MemesManager.shared.deleteMeme(at: indexPath)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                actionPerformed(true)
        }
        
        let cancelAction = UIContextualAction(style: .normal, title: ActionTitle.cancel) {
            
            (contextualAction, view, actionPerformed) in
                log.verbose("cancel action selected")
                actionPerformed(false)
        }
        
        cancelAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [deleteAction, cancelAction])
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        log.verbose("move row at \(sourceIndexPath) to \(destinationIndexPath)")
        MemesManager.shared.moveMeme(from: sourceIndexPath, to: destinationIndexPath)
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemesManager.shared.count
    }

}



// MARK: -
// MARK: - Table View Delegate

extension SentMemesTableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: IB.StoryboardID.memeDetailViewController) as! MemeDetailViewController
        memeDetailVC.memeToDisplay = MemesManager.shared.meme(at: indexPath)

        navigationController?.pushViewController(memeDetailVC, animated: true)
    }

}



// MARK: -
// MARK: - Private Helpers

private extension SentMemesTableViewController {

    enum ActionTitle {
        static let cancel = "Cancel"
        static let delete = "Delete"
    }

}
