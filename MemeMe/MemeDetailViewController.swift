//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Felix Christmann-Jacoby on 13.06.15.
//  Copyright (c) 2015 Felix Christmann-Jacoby. All rights reserved.
//

import UIKit

/* Display a Meme in full size */
final class MemeDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    internal var meme: Meme!
    internal var memeIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editMeme");
        var deleteButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "deleteMeme");
        self.navigationItem.rightBarButtonItems = [deleteButton, editButton];
    }
    
    override internal func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = true
        imageView!.image = meme!.memedImage
    }

    // Present the meme editor with the actual meme as template
    func editMeme() {
        var memeEditorVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditor") as! MemeEditor
        memeEditorVC.meme = meme
        self.presentViewController(memeEditorVC, animated: true, completion: nil)
    }
    
    // Delete the actual meme and pop the view controller
    func deleteMeme() {
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(memeIndex!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override internal func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.hidden = false
    }
}
