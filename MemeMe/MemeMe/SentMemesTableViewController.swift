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

    // MARK: - IB Actions

    @IBAction func barButtonWasTapped(_ barButtonItem: UIBarButtonItem) {

        guard let systemItem = UIBarButtonItem.SystemItem(rawValue: barButtonItem.tag) else {
            assertionFailure("Received action from unknown bar button item = \(barButtonItem)")
            return
        }

        switch systemItem {
        case .add: addButtonWasTapped()
        default:   assertionFailure("Received action from bar button \(systemItem) is not processed")
        }

    }

    // MARK: - View Management

    override func viewDidLoad() {
        super.viewDidLoad()

        addNotificationObservers()
        navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
}



// MARK: - 
// MARK: - Notifications

extension SentMemesTableViewController {

    @objc func processNotification(_ notification: Notification) {

        switch notification.name {

        case NotificationName.MemeWasAdded: tableView.reloadData()
            
        default: assertionFailure("Received unknown notification = \(notification)")
        }
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: IB.ReuseID.SentMemesTableViewCell, for: indexPath) as! SentMemesTableViewCell

        cell.topPhrase!.text    = meme.topPhrase
        cell.bottomPhrase!.text = meme.bottomPhrase
        cell.memeView!.image    = meme.memedImage

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MemesManager.shared.deleteMeme(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: ActionTitle.Delete) {
            
            (contextualAction, view, actionPerformed) in
                
                MemesManager.shared.deleteMeme(at: indexPath)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.isEditing = false
        }
        
        let cancelAction = UIContextualAction(style: .normal, title: ActionTitle.Cancel) {
            
            (contextualAction, view, actionPerformed) in
                
                self.isEditing = false
            
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, cancelAction])
    }

//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        assert(tableView == self.tableView, "Unexpected table view requesting edit actions")
//
//        let deleteAction = UITableViewRowAction(style: .default, title: ActionTitle.Delete) { (action, indexPath) -> Void in
//            MemesManager.shared.deleteMeme(at: indexPath)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            self.isEditing = false
//        }
//
//        let cancelAction = UITableViewRowAction(style: .default, title: ActionTitle.Cancel) { (action, indexPath) -> Void in
//            self.isEditing = false
//        }
//
//        cancelAction.backgroundColor = UIColor.blue
//
//        return [cancelAction, deleteAction]
//    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
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
        let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: IB.StoryboardID.MemeDetailViewController) as! MemeDetailViewController
        memeDetailVC.memeToDisplay = MemesManager.shared.meme(at: indexPath)

        navigationController?.pushViewController(memeDetailVC, animated: true)
    }

}



// MARK: -
// MARK: - Private Helpers

private extension SentMemesTableViewController {

    struct ActionTitle {
        static let Cancel = "Cancel"
        static let Delete = "Delete"
    }

    struct Selector {
        static let ProcessNotification = #selector(processNotification(_:))
    }

    func addButtonWasTapped() {
        let memeEditor = storyboard?.instantiateViewController(withIdentifier: IB.StoryboardID.MemeEditorNavigationController) as! UINavigationController
        present(memeEditor, animated: true, completion: nil)
    }

    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: Selector.ProcessNotification, name: NotificationName.MemeWasAdded, object: nil)
    }

}
