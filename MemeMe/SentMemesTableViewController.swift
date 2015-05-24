//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Steven on 21/05/2015.
//  Copyright (c) 2015 Horsemen. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Variables
    @IBOutlet weak var sentMemesTable: UITableView!
    
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var addButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    
    var memes: [Meme]!
    
    // MARK: - View Lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = false
        
        // Retrieve memes data from App Delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
        
        cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelAction")
        
        sentMemesTable.reloadData()
        
        if memes.count > 0 {
            // Enable edit button if meme exists
            editButton.enabled = true
        } else {
            // Disable edit button if no memes
            editButton.enabled = false
        }
    }
    
    // MARK: IB Actions
    /**
    Show meme editor screen
    
    :param: sender
    */
    @IBAction func showMemeEditor(sender: UIBarButtonItem) {
        let memeEditor = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        navigationController!.pushViewController(memeEditor, animated: true)
    }
    
    @IBAction func editAction(sender: UIBarButtonItem) {
        sentMemesTable.setEditing(true, animated: true)
        updateBarButtonState()
    }
    
    func cancelAction() {
        sentMemesTable.setEditing(false, animated: true)
        updateBarButtonState()
    }
    
    func updateBarButtonState() {
        // If in editing mode, show delete and cancel button
        if sentMemesTable.editing {
            navigationItem.leftBarButtonItem = cancelButton
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = addButton
            navigationItem.leftBarButtonItem = editButton
        }
    }
    
    // MARK: - Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SentMemesTableViewCell") as! SentMemesTableViewCell
        let meme = memes[indexPath.row]
        
        // Set the name and image for row
        cell.titleLabel?.text = meme.topText + " " + meme.bottomText
        cell.memeImageView?.image = meme.memeImage
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Instantiate MemeDetailViewController
        let memeDetailView = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        // Pass selected meme
        memeDetailView.selectedMeme = memes[indexPath.row]
        memeDetailView.selectedIndex = indexPath.row
        
        // Show meme detail view
        navigationController!.pushViewController(memeDetailView, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            // Remove the deleted meme from memes array
            memes.removeAtIndex(indexPath.row)
            
            // Update shared memes
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes = memes
            
            // Delete the row
            sentMemesTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if memes.count == 0 {
            // End editing session if no more meme
            cancelAction()
        }
    }

}