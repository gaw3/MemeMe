//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Gregory White on 10/19/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import CoreGraphics
import Foundation
import UIKit

final class SentMemesCollectionViewController: UICollectionViewController {

    // MARK: - Private Constants

    fileprivate struct Layout {
        static let NumberOfCellsAcrossInPortrait:  CGFloat = 3.0
        static let NumberOfCellsAcrossInLandscape: CGFloat = 5.0
        static let MinimumInteritemSpacing:        CGFloat = 3.0
    }

    fileprivate struct SEL {
        static let MemesWereModified = #selector(memesWereModified(_:))
    }

    fileprivate struct UI {
        static let CollectionCellReuseID = "SentMemesCollectionViewCell"
    }

    // MARK: - IB Outlets

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    // MARK: - View Events

    override func viewDidLoad() {
        super.viewDidLoad()

        addNotificationObservers()

        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UI.CollectionCellReuseID)
        collectionView?.backgroundColor = UIColor.white

        flowLayout.minimumInteritemSpacing = Layout.MinimumInteritemSpacing
        flowLayout.minimumLineSpacing      = Layout.MinimumInteritemSpacing
    }

    // MARK: - View Layout

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let numOfCellsAcross: CGFloat = UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
            ? Layout.NumberOfCellsAcrossInPortrait : Layout.NumberOfCellsAcrossInLandscape
        let itemWidth: CGFloat = (view.frame.size.width - (flowLayout.minimumInteritemSpacing * (numOfCellsAcross - 1))) / numOfCellsAcross

        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth) // yes, a square on purpose
    }

    // MARK: - IB Actions

    @IBAction func addButtonWasTapped(_ sender: UIBarButtonItem) {
        let memeEditor = storyboard?.instantiateViewController(withIdentifier: StoryboardID.MemeEditorNavCtlr) as! UINavigationController
        present(memeEditor, animated: true, completion: nil)
    }

    // MARK: - NSNotifications

    func memesWereModified(_ notification: Notification) {
        assert(notification.name == NotificationName.MemeWasAdded ||
               notification.name == NotificationName.MemeWasDeleted ||
               notification.name == NotificationName.MemeWasMoved, "received unexpected NSNotification")

        collectionView?.reloadData()
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        assert(collectionView == self.collectionView, "Unexpected collection view reqesting cell of item at index path")

        let meme = MemesManager.shared.memeAtIndexPath(indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UI.CollectionCellReuseID, for: indexPath)

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

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        assert(collectionView == self.collectionView, "Unexpected collection view selected an item")

        let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: MemeDetailViewController.UI.StoryboardID) as! MemeDetailViewController
        memeDetailVC.memeToDisplay = MemesManager.shared.memeAtIndexPath(indexPath)

        navigationController?.pushViewController(memeDetailVC, animated: true)
    }

    // MARK: - Private Helpers

    fileprivate func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: SEL.MemesWereModified, name: NotificationName.MemeWasAdded,   object: nil)
        NotificationCenter.default.addObserver(self, selector: SEL.MemesWereModified, name: NotificationName.MemeWasDeleted, object: nil)
        NotificationCenter.default.addObserver(self, selector: SEL.MemesWereModified, name: NotificationName.MemeWasMoved,   object: nil)
    }
    
}
