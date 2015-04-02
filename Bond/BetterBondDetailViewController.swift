//
//  BetterBondDetailViewController.swift
//  Bond
//
//  Created by Andrew Breckenridge on 3/26/15.
//  Copyright (c) 2015 Bond Labs. All rights reserved.
//

import UIKit

class BetterBondDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var id: Int?
    var userID: Int?
    var name: String?
    var traits: String?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var traitCollectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        traitCollectionView.delegate = self
        traitCollectionView.dataSource = self
    }

    
    func kevinSetup(id: Int) {
        let newTraits: String = self.traits != nil ? self.traits! : "000000000000000000000000000000000000000000000"
        let myTraits = UserAccountController.sharedInstance.currentUser.traitsString
        let myTraitsFixed: String = myTraits != nil ? myTraits! : "000000000000000000000000000000000000000000000"
        let	combinedString = myTraitsFixed & newTraits
        
        var activities = BondBond.getTraitsFromString(combinedString) as [String]
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellID", forIndexPath: indexPath) as UICollectionViewCell
        
        cell.backgroundColor = UIColor.greenColor()
        
        return cell
    }


}
