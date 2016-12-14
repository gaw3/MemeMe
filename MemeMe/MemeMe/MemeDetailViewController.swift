//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Gregory White on 10/23/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

final class MemeDetailViewController: UIViewController {

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
    fileprivate var memeDetailView: UIImageView!

    // MARK: - View Events

    override func viewDidLoad() {
        super.viewDidLoad()
        
        memeDetailView = UIImageView()
        memeDetailView.contentMode = .scaleAspectFit
        memeDetailView.isHidden    = false

        view.addSubview(memeDetailView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        resetMemeDetailView()
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

    func resetMemeDetailView() {
        memeDetailView.frame = view.bounds

        let widthScale         = view.frame.size.width / memeToDisplay.memedImage.size.width
        let heightScale        = view.frame.size.height / memeToDisplay.memedImage.size.height
        let scaleToUse         = min(widthScale, heightScale)
        let widthAfterScaling  = memeToDisplay.memedImage.size.width * scaleToUse
        let heightAfterScaling = memeToDisplay.memedImage.size.height * scaleToUse

        memeDetailView.image        = memeToDisplay.memedImage
        memeDetailView.frame.size   = CGSize(width: widthAfterScaling, height: heightAfterScaling)
        memeDetailView.frame.origin = CGPoint(x: (view.frame.size.width - widthAfterScaling) / 2,
                                              y: (view.frame.size.height - heightAfterScaling) / 2)
    }

}
