//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Steven on 21/05/2015.
//  Copyright (c) 2015 Horsemen. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: Variables
    @IBOutlet weak var sentMemesCollection: UICollectionView!
    
    var memes: [Meme]!
    
    // MARK: - View Lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = false
        
        // Retrieve memes object from App Delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
        
        // Reload collection
        sentMemesCollection.reloadData()
    }
    
    // MARK: IB Actions
    /**
    Show Meme Editor Screen
    
    :param: sender
    */
    @IBAction func showMemeEditor(sender: UIBarButtonItem) {
        let memeEditor = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        navigationController!.pushViewController(memeEditor, animated: true)
    }
    
    // MARK: - Collection View Delegate & Data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // Dequeue collection cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SentMemesCollectionViewCell", forIndexPath: indexPath) as! SentMemesCollectionViewCell
        let meme = memes[indexPath.row]
        
        // Set the cell image with meme image
        cell.memeImage?.image = meme.memeImage
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Instantiate meme detail view controller
        let memeDetailView = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        // Pass the selected meme information
        memeDetailView.selectedMeme = memes[indexPath.row]
        memeDetailView.selectedIndex = indexPath.row
        // Display meme detail view
        navigationController!.pushViewController(memeDetailView, animated: true)
    }
    
}
