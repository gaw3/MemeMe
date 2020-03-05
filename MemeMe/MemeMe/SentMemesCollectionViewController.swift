//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Gregory White on 10/19/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import CoreGraphics
import UIKit

// MARK: -
// MARK: - 

final class SentMemesCollectionViewController: UICollectionViewController {

    // MARK: - IB Outlets

    @IBOutlet weak var addButton:  UIBarButtonItem!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    // MARK: - IB Actions

    @IBAction func barButtonWasTapped(_ barButtonItem: UIBarButtonItem) {

        switch barButtonItem {
        case addButton: performSegue(withIdentifier: IB.SegueID.collectionToMemeEditor, sender: self)
        default:
            assertionFailure()
            log.error("Received event from unknown bar button item = \(barButtonItem)")
        }

    }

    // MARK: - View Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logViewDidLoad()
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: IB.ReuseID.sentMemesCollectionViewCell)
        collectionView.backgroundColor = UIColor.white
        
        flowLayout.minimumInteritemSpacing = Layout.minimumInteritemSpacing
        flowLayout.minimumLineSpacing      = Layout.minimumInteritemSpacing
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logViewWillAppear()
        collectionView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logViewWillLayoutSubviews()

        let numOfCellsAcross = CGFloat(UIDevice.current.orientation.isPortrait ? Layout.numberOfCellsAcrossInPortrait : Layout.numberOfCellsAcrossInLandscape)
        let itemWidth        = CGFloat((view.frame.size.width - (flowLayout.minimumInteritemSpacing * (numOfCellsAcross - 1))) / numOfCellsAcross)

        flowLayout.itemSize  = CGSize(width: itemWidth, height: itemWidth) // yes, a square on purpose
    }
    
}



// MARK: -
// MARK: - Collection View Data Source

extension SentMemesCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let meme = MemesManager.shared.meme(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IB.ReuseID.sentMemesCollectionViewCell, for: indexPath)

        cell.backgroundView = UIImageView(image: meme.memedImage)

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MemesManager.shared.count
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

}



// MARK: -
// MARK: - Collection View Delegate

extension SentMemesCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: IB.StoryboardID.memeDetailViewController) as! MemeDetailViewController
        memeDetailVC.memeToDisplay = MemesManager.shared.meme(at: indexPath)

        navigationController?.pushViewController(memeDetailVC, animated: true)
    }

}



// MARK: -
// MARK: - Private Helpers

private extension SentMemesCollectionViewController {

    enum Layout {
        static let numberOfCellsAcrossInPortrait  = CGFloat(3.0)
        static let numberOfCellsAcrossInLandscape = CGFloat(5.0)
        static let minimumInteritemSpacing        = CGFloat(3.0)
    }

}
