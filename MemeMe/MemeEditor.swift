//
//  MemeEditor.swift
//  MemeMe
//
//  Created by Felix Christmann-Jacoby on 02.06.15.
//  Copyright (c) 2015 Felix Christmann-Jacoby. All rights reserved.
//

import UIKit

/* Create a Meme, share and save it */
final class MemeEditor: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    var meme: Meme?
    
    // Set the text attributes for the top and bottom textfields
    private let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSStrokeWidthAttributeName: NSNumber(float: -5.0),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSForegroundColorAttributeName: UIColor.whiteColor()
    ]
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        textTop.delegate = self
        textBottom.delegate = self
        
        textTop.defaultTextAttributes = memeTextAttributes
        textBottom.defaultTextAttributes = memeTextAttributes
        
        textTop.textAlignment = .Center
        textBottom.textAlignment = .Center

        if let meme = self.meme {
            shareButton.enabled = true
        } else {
            shareButton.enabled = false
        }
    }
    
    override internal func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // If a meme did get received present it in the editor
        if let meme = self.meme {
            textTop.text = meme.textTop
            textBottom.text = meme.textBottom
            backgroundImage.image = meme.image
        }
        
        // Disable camera button if no camera is available in the device
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
    }
    
    
    // Observe UIKeyboardWillShowNotification/UIKeyboardWillHideNotification
    internal func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Stop observing UIKeyboardWillShowNotification/UIKeyboardWillHideNotification
    internal func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Shift the view in response to the UIKeyboardWillShowNotification
    internal func keyboardWillShow(notification: NSNotification) {
        if textBottom.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // Shift the view in response to the UIKeyboardWillHideNotification:
    internal func keyboardWillHide(notification: NSNotification) {
        if textBottom.isFirstResponder() {
            view.frame.origin.y = 0
        }
    }
    
    // Get the keyboard height from the notification’s userInfo dictionary
    internal func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // Resign first responder when return key is pressed
    internal func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    // If available open the photo library using UIImagePickerController
    @IBAction internal func openPhotoLibrary(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    // If available open the camera using UIImagePickerController
    @IBAction internal func openCamera(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    // DELEGATE: When imagePickerController did finish picking an image set this image as backgroundImage for the Meme
    internal func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject: AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            backgroundImage.image = image
            shareButton.enabled = true
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // Generate and return the memed image as UIImage from the view context without the toolbar&navbar
    internal func generateMemedImage() -> UIImage
    {
        //hide toolbar&navbar
        toolbar.hidden = true
        navbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //show toolbar&navbar
        toolbar.hidden = false
        navbar.hidden = false
        
        return memedImage
    }
    
    // Create the Meme and add it to the memes array in the Application Delegate
    private func save(memedImage: UIImage) {
        //Create the meme
        let meme = Meme(textTop: textTop.text!, textBottom: textBottom.text!, image: backgroundImage.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    // Share the memedImage with the UIActivityViewController at save it at completion
    @IBAction internal func share(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let objectsToShare = [memedImage]
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = { (activity, success, items, error) in
            
                let TabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
                self.presentViewController(TabBarController, animated: true, completion: nil)
        }
        
        presentViewController(activityVC, animated: true, completion: {self.save(memedImage)})
    }

    // Unsubscribe from notifications
    override internal func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
}

