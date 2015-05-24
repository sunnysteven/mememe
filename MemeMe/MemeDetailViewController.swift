//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Steven on 23/05/2015.
//  Copyright (c) 2015 Horsemen. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    // MARK: Variables
    @IBOutlet weak var memeImageView: UIImageView!
    
    var editButton: UIBarButtonItem!
    var deleteButton: UIBarButtonItem!
    
    var selectedMeme: Meme!
    var selectedIndex: Int!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editAction")
        deleteButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "deleteAction")
        navigationItem.rightBarButtonItems = [deleteButton, editButton]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memeImageView.image = selectedMeme.memeImage
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    // MARK: Actions
    /**
    Action when delete button is tapped
    */
    func deleteAction() {
        // Delete the memes for the selected index from app delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(selectedIndex)
        // Navigate back to previous view
        navigationController?.popViewControllerAnimated(true)
    }
    
    /**
    Action when edit button is tapped
    
    1. Instantiate meme editor view
    2. Pass the selected meme instance to the view
    3. Show meme editor screen
    */
    func editAction() {
        // Instantiate meme editor view
        let memeEditorView = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        // Pass parameter
        memeEditorView.editMeme = selectedMeme
        memeEditorView.memeIndex = selectedIndex
        
        // Show meme editor
        tabBarController?.tabBar.hidden = false
        navigationController?.pushViewController(memeEditorView, animated: true)
    }

}
