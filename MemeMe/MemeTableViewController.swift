//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Felix Christmann-Jacoby on 13.06.15.
//  Copyright (c) 2015 Felix Christmann-Jacoby. All rights reserved.
//

import UIKit

/* Display sent memes in a table view style */

final class MemeTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    //MARK: table view data source
    //MARK: table view delegate
    
    //reload the table view before the view appears
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    // DELEGATE - Set the Number of rows to the amount of the memes in the memes array
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
    }
    
    // DELEGATE - Set the content of the cells
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        let meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = "\(meme.textTop)-\(meme.textBottom)"
        cell.imageView?.image = meme.memedImage
        return cell
    }
    
    // DELEGATE - When a Row is selected show the Meme Detail View with the selected Meme
    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let memeDetailVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        memeDetailVC.meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        memeDetailVC.memeIndex = indexPath.row
        
        self.navigationController!.pushViewController(memeDetailVC, animated: true)
    }
    
    // DELEGATE - Delete the selected Meme and reload the table views data
    internal func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    // Sets the title of the edit button and toggles the table views editing mode
    @IBAction internal func edit(sender: UIBarButtonItem) {
        if (self.tableView.editing) {
            editButton.title = "Edit"
            self.tableView.setEditing(false, animated: true)
        } else {
            editButton.title = "Done"
            self.tableView.setEditing(true, animated: true)
        }
    }
    
}
