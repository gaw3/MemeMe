//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Gregory White on 10/23/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

final class MemeDetailViewController: UIViewController {

    // MARK: - IB Outlets
    
    @IBOutlet weak var detailImage: UIImageView!

    // MARK: - IB Actions

    @IBAction func barButtonWasTapped(_ barButtonItem: UIBarButtonItem) {

        let systemItem = UIBarButtonSystemItem(rawValue: barButtonItem.tag)

        guard systemItem != nil else {
            fatalError("Received action from unknown bar button item = \(barButtonItem)")
        }

        switch systemItem! {

        case .edit: editButtonWasTapped()

        default: fatalError("Received action from system item \(systemItem) is not processed")
        }

    }

    // MARK: - Variables

    var memeToDisplay: Meme!

    // MARK: - View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailImage.image = memeToDisplay.memedImage
    }
    
}



// MARK: -
// MARK: - Private Helpers

private extension MemeDetailViewController {

    func editButtonWasTapped() {
        let memeEditorNavCtlr = storyboard?.instantiateViewController(withIdentifier: IB.StoryboardID.MemeEditorNavigationController) as! UINavigationController
        let memeEditorVC      = memeEditorNavCtlr.viewControllers[0] as! MemeEditorViewController

        memeEditorVC.memeToEdit = memeToDisplay
        present(memeEditorNavCtlr, animated: true, completion: nil)
    }

}
