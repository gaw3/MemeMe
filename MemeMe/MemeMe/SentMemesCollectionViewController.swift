//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Gregory White on 10/19/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import CoreGraphics
import UIKit

final class SentMemesCollectionViewController: UICollectionViewController {

    // MARK: - IB Outlets

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    // MARK: - IB Actions

    @IBAction func barButtonWasTapped(_ barButtonItem: UIBarButtonItem) {
        let systemItem = UIBarButtonSystemItem(rawValue: barButtonItem.tag)

        guard systemItem != nil else {
            fatalError("Received action from unknown bar button item = \(barButtonItem)")
        }

        switch systemItem! {

        case .add: addButtonWasTapped()

        default: fatalError("Received action from system item \(systemItem!) is not processed")
        }

    }

    // MARK: - View Layout

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let numOfCellsAcross = CGFloat(UIDeviceOrientationIsPortrait(UIDevice.current.orientation) ? Layout.NumberOfCellsAcrossInPortrait : Layout.NumberOfCellsAcrossInLandscape)
        let itemWidth        = CGFloat((view.frame.size.width - (flowLayout.minimumInteritemSpacing * (numOfCellsAcross - 1))) / numOfCellsAcross)

        flowLayout.itemSize  = CGSize(width: itemWidth, height: itemWidth) // yes, a square on purpose
    }
    
    // MARK: - View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNotificationObservers()
        
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: IB.ReuseID.SentMemesCollectionViewCell)
        collectionView?.backgroundColor = UIColor.white
        
        flowLayout.minimumInteritemSpacing = Layout.MinimumInteritemSpacing
        flowLayout.minimumLineSpacing      = Layout.MinimumInteritemSpacing
    }
    
}



// MARK: - 
// MARK: - Notifications

extension SentMemesCollectionViewController {

    func processNotification(_ notification: Notification) {

        switch notification.name {

        case NotificationName.MemeWasAdded,
             NotificationName.MemeWasDeleted,
             NotificationName.MemeWasMoved: collectionView?.reloadData()

        default: fatalError("Received unknown notification = \(notification)")
        }
        
    }
    
}



// MARK: -
// MARK: - Collection View Data Source

extension SentMemesCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        assert(collectionView == self.collectionView, "Unexpected collection view reqesting cell of item at index path")

        let meme = MemesManager.shared.meme(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IB.ReuseID.SentMemesCollectionViewCell, for: indexPath)

        cell.backgroundView = UIImageView(image: meme.memedImage)

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assert(collectionView == self.collectionView, "Unexpected collection view reqesting number of items in section")

        return MemesManager.shared.count
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        assert(collectionView == self.collectionView, "Unexpected collection view reqesting number of sections in view")
        
        return 1
    }

}



// MARK: -
// MARK: - Collection View Delegate

extension SentMemesCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        assert(collectionView == self.collectionView, "Unexpected collection view selected an item")

        let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: IB.StoryboardID.MemeDetailViewController) as! MemeDetailViewController
        memeDetailVC.memeToDisplay = MemesManager.shared.meme(at: indexPath)

        navigationController?.pushViewController(memeDetailVC, animated: true)
    }

}



// MARK: -
// MARK: - Private Helpers

private extension SentMemesCollectionViewController {

    struct Layout {
        static let NumberOfCellsAcrossInPortrait  = CGFloat(3.0)
        static let NumberOfCellsAcrossInLandscape = CGFloat(5.0)
        static let MinimumInteritemSpacing        = CGFloat(3.0)
    }

    struct Selector {
        static let ProcessNotification = #selector(processNotification(_:))
    }

    func addButtonWasTapped() {
        let memeEditor = storyboard?.instantiateViewController(withIdentifier: IB.StoryboardID.MemeEditorNavigationController) as! UINavigationController
        present(memeEditor, animated: true, completion: nil)
    }

    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: Selector.ProcessNotification, name: NotificationName.MemeWasAdded,   object: nil)
        NotificationCenter.default.addObserver(self, selector: Selector.ProcessNotification, name: NotificationName.MemeWasDeleted, object: nil)
        NotificationCenter.default.addObserver(self, selector: Selector.ProcessNotification, name: NotificationName.MemeWasMoved,   object: nil)
    }

}
