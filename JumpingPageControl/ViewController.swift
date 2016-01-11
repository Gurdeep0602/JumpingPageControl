//
//  ViewController.swift
//  JumpingPageControl
//
//  Created by Gurdeep Singh on 10/01/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, JumpingPageControlDelegate {

    @IBOutlet weak var pageControl: JumpingPageControl!
    
    @IBOutlet weak var colorCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        colorCollection.pagingEnabled = true
        colorCollection.backgroundColor = UIColor.whiteColor()
        
        colorCollection.dataSource = self
        colorCollection.delegate = self
    
        pageControl.currentPage = 1
    
        pageControl.addTarget(self, action: "dummyFunc:", forControlEvents: UIControlEvents.ValueChanged)
        pageControl.delegate = self
        
    }

    func dummyFunc(pageControl : JumpingPageControl) {
    
        print("pageControl.currentPage : \(pageControl.currentPage)")
    }
    
    func jumpingPageControl(jumpingPageControl : JumpingPageControl, manuallyUpdatedToCurrentPage currentPage : Int) {
    
        print("manuallyUpdatedCurrentPage : \(currentPage)")
        
        let idx = NSIndexPath(forItem: currentPage-1, inSection: 0)
        colorCollection.scrollToItemAtIndexPath(idx, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return Int(pageControl.numberOfPages)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("dummyCell", forIndexPath: indexPath) as! DummyCell

        cell.titleLbl.text = "\(indexPath.row+1)"
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    
        let screensize = UIScreen.mainScreen().bounds
        return CGSizeMake(screensize.width, screensize.height)
    }
    
}

class DummyCell : UICollectionViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    
}
