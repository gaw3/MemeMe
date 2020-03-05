//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Gregory White on 10/23/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

// MARK: -
// MARK: -

final class MemeDetailViewController: UIViewController {

    // MARK: - IB Outlets
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var editButton:  UIBarButtonItem!
    
    // MARK: - IB Actions

    @IBAction func barButtonWasTapped(_ barButtonItem: UIBarButtonItem) {

        switch barButtonItem {
        case editButton: performSegue(withIdentifier: IB.SegueID.detailToMemeEditor, sender: self)
        default:
            assertionFailure()
            log.error("Received action from system item \(barButtonItem) is not processed")
        }

    }

    // MARK: - Variables

    var memeToDisplay: Meme!

    // MARK: - View Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailImage.image = memeToDisplay.memedImage
    }
    
}



// MARK: -
// MARK: - Navigation

extension MemeDetailViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        case IB.SegueID.detailToMemeEditor: prepare(forMemeEditor: segue)
        default:
            assertionFailure()
            log.error("for unknown segue ID = \(segue.identifier!)")
        }
        
    }
    
}



// MARK: -
// MARK: - Private Helpers

private extension MemeDetailViewController {

    func prepare(forMemeEditor segue: UIStoryboardSegue) {
        let nc = segue.destination    as! UINavigationController
        let sc = nc.topViewController as! MemeEditorViewController
        
        sc.memeToEdit = memeToDisplay
    }

}
