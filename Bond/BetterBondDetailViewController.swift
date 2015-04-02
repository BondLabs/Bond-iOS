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
    
    var actButtons = [ActivityView]()
    
    @IBOutlet weak var profileImageView: CircleImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var traitCollectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        traitCollectionView.delegate = self
        traitCollectionView.dataSource = self
        
        self.navigationItem.title = self.name
        
        bryceSetup(id!)
    }

    
    func bryceSetup(id: Int) {
        let newTraits: String = self.traits != nil ? self.traits! : "000000000000000000000000000000000000000000000"
        let myTraits = UserAccountController.sharedInstance.currentUser.traitsString
        let myTraitsFixed: String = myTraits != nil ? myTraits! : "000000000000000000000000000000000000000000000"
        let	combinedString = myTraitsFixed & newTraits
        
        var activities = BondBond.getTraitsFromString(combinedString) as [String]
     
        profileImageView.performSetup(1)
        profileImageView.layer.borderColor = UIColor.bl_azureRadianceColor().CGColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
        for a in activities {
            var actView = ActivityView()
            actView.frame.size = CGSizeMake(70, 110)
            
            actView.setup(a)
            self.actButtons.append(actView)
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actButtons.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellID", forIndexPath: indexPath) as UICollectionViewCell
        
        cell.addSubview(actButtons[indexPath.row])
        
        
        return cell
    }


}
