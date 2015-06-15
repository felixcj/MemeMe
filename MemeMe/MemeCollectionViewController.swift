//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Felix Christmann-Jacoby on 13.06.15.
//  Copyright (c) 2015 Felix Christmann-Jacoby. All rights reserved.
//

import Foundation

import UIKit

/* Display sent memes in a collection view style */
final class MemeCollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    //MARK: collection view data source
    //MARK: collection view delegate
    
    //reload the collection view before the view appears
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    
    // DELEGATE - Set the number of items to the amount of the memes in the memes array
    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
    }
    
    // DELEGATE - Set the content of the cells
    internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        
        // Set the name and image
        cell.image.image = meme.memedImage
        
        return cell
    }
    
    // DELEGATE - When an item is selected show the MemeDetailViewController with the selected Meme
    internal func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        
        let memeDetailVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        memeDetailVC.meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        memeDetailVC.memeIndex = indexPath.row
        
        navigationController!.pushViewController(memeDetailVC, animated: true)
    }
    

}
    

