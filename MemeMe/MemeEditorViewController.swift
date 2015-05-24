//
//  MasterViewController.swift
//  MemeMe
//
//  Created by Steven on 16/05/2015.
//  Copyright (c) 2015 Horsemen. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    // MARK: Variables
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    var shareButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    
    /// If in editing state, this variables will be passed from Meme Detail View
    var editMeme: Meme!
    var memeIndex: Int!
    
    /// Default text attributes for MemeMe
    let memeTextAttributes = [
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue", size: 40)!,
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSStrokeWidthAttributeName : -4.0
    ]
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set text field delegates
        topText.delegate = self
        bottomText.delegate = self
        
        // Set navigation item
        shareButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "showShareMenu")
        cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "returnToList")
        navigationItem.rightBarButtonItem = cancelButton
        navigationItem.leftBarButtonItem = shareButton
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // If in edit state, prepopulate the text fields and image view
        if let editMeme = self.editMeme {
            topText.text = editMeme.topText
            bottomText.text = editMeme.bottomText
            memeImageView.image = editMeme.originalImage
        } else {
            // Disable share button if not in edit mode
            shareButton.enabled = false;
        }
        
        // Disable camera button if camera is not available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Default Text Fields behavior
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .Center
        bottomText.textAlignment = .Center
        
        // Hide tab bar 
        tabBarController?.tabBar.hidden = true
        
        // Subscribe to keyboard event
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe from keyboard event
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Class Methods
    /**
    Hide status bar
    */
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    /**
    Display image picker
    
    :param: source Type of image picker, default to PhotoLibrary
    */
    func displayImagePicker(source: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.PhotoLibrary) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    /**
    Subscribe to keyboard will show event
    */
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /**
    Unsubscribe from keyboard will show event
    */
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /**
    Shift view up if bottom text field is being edited
    
    :param: notification
    */
    func keyboardWillShow(notification: NSNotification) {
        if ( bottomText.isFirstResponder() ) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    /**
    Shift view down if bottom text field finished editing
    
    :param: notification
    */
    func keyboardWillHide(notification: NSNotification) {
        if ( bottomText.isFirstResponder() ) {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    /**
    Return height of the keyboard
    
    :param: notification
    */
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    /**
    Generate the meme by capturing image of the current screen
    
    :returns: The meme image (instance of UIImage)
    */
    func generateMeme() -> UIImage {
        
        // Hide toolbar and navbar
        toolbar.hidden = true
        navigationController?.navigationBarHidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        toolbar.hidden = false
        navigationController?.navigationBarHidden = false
        
        return memeImage
    }
    
    /**
    Save current meme
    */
    func saveMeme( memeImage: UIImage ) {
        
        var meme = Meme(topText: topText.text, bottomText: bottomText.text, originalImage: memeImageView.image!, memeImage: memeImage)
        
        if let memeIndex = self.memeIndex {
            // If in editing mode, replace the app delegate's memes array
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes[memeIndex] = meme            
        } else {
            // If not in editing mode, add to app delegate's memes array
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        }
        
    }
    
    /**
    Return to meme list view
    */
    func returnToList() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    /**
    Show share menu
    
    :param: sender Share icon bar button item
    */
    func showShareMenu() {
        
        let memeImage = generateMeme()
        
        let shareView = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        shareView.completionWithItemsHandler = {
            (activity, success, items, error) in
            
            if success {
                // Save the meme
                self.saveMeme( memeImage )
                // Navigate to sent memes view
                self.navigationController!.popToRootViewControllerAnimated(true)
                
            }
        }
        presentViewController(shareView, animated: true, completion: nil)
        
    }
    
    // MARK: IB Actions
    
    /**
    Show photo album picker
    
    :param: sender Album bar button item
    */
    @IBAction func showPhotoAlbum(sender: UIBarButtonItem) {
        displayImagePicker()
    }
    
    /**
    Show camera
    
    :param: sender Camera bar button item
    */
    @IBAction func showCamera(sender: UIBarButtonItem) {
        displayImagePicker(source: UIImagePickerControllerSourceType.Camera)
    }
    
    // MARK: - Delegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        // Retrieve the picked image and display it in the ImageView
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            memeImageView.image = image
        }
        
        dismissViewControllerAnimated(true) {
            // Enable share button
            self.shareButton.enabled = true
        }
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Empty textfield
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Remove keyboard when 'enter' pressed
        textField.resignFirstResponder()
        return true
    }

}

