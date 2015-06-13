//
//  MemeEditor.swift
//  MemeMe
//
//  Created by Felix Christmann-Jacoby on 02.06.15.
//  Copyright (c) 2015 Felix Christmann-Jacoby. All rights reserved.
//

import UIKit

class MemeEditor: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var top: UITextField!
    @IBOutlet weak var bottom: UITextField!
    @IBOutlet weak var toolbar: UINavigationBar!
    @IBOutlet weak var navbar: UIToolbar!
    @IBOutlet weak var share: UIBarButtonItem!
    
    let memeTextAttributes = [
        NSStrokeWidthAttributeName : NSNumber(float: 3.0),
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSForegroundColorAttributeName : UIColor.whiteColor()
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.top.delegate = self
        self.bottom.delegate = self
        self.top.defaultTextAttributes = self.memeTextAttributes
        self.bottom.defaultTextAttributes = self.memeTextAttributes
        
        self.top.textAlignment = .Center
        self.bottom.textAlignment = .Center
        
        self.share.enabled = false

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

        self.camera.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
        
    }
    
    
    //Observe UIKeyboardWillShowNotification:
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    //Shift the view in response to the UIKeyboardWillShowNotification:
    func keyboardWillShow(notification: NSNotification) {
        if bottom.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottom.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    //Get the keyboard height from the notification’s userInfo dictionary:
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // Unsubscribe
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.memeImage.image = image
            self.share.enabled = true

        }
        memeImage.contentMode = UIViewContentMode.ScaleAspectFit
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func openAlbum(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func openCamera(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func generateMemedImage() -> UIImage
    {
        //hide toolbars
        self.toolbar.hidden = true
        self.navbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        //show toolbars
        self.toolbar.hidden = false
        self.navbar.hidden = false
        
        return memedImage
    }
    
    func save(memedImage: UIImage) {
        //Create the meme
        var meme = Meme(textTop: self.top.text!, textBottom: self.bottom.text!, image: self.memeImage.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }

    @IBAction func share(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let objectsToShare = [memedImage]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        self.presentViewController(activityVC, animated: true, completion: {self.save(memedImage)})
    }
}

