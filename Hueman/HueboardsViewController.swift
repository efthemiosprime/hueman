//
//  HueboardsViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/4/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class HueboardsViewController: UICollectionViewController {
    
    var  colors = [UIColor]()
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        if let patternImage = UIImage(named: "Pattern") {
//            view.backgroundColor = UIColor(patternImage: patternImage)
//        }
        
//      
        
        colors = [
            UIColorFromRGB(0x93648D),
            UIColorFromRGB(0x7BC8A4),
            UIColorFromRGB(0xf8b243),
            UIColorFromRGB(0xEACD53),
            UIColorFromRGB(0xe2563b),
            UIColorFromRGB(0x34b5d4)
        ]
        //collectionView!.backgroundColor = UIColor.clearColor()
        collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        
        let layout = collectionViewLayout as! HueboardsLayout
        layout.cellPadding = 5
        layout.delegate = self
        layout.numberOfColumns = 2
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem!.title = "hueboards"

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension HueboardsViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HueboardCell", forIndexPath: indexPath) as! HueboardCell
        let randomIndex = Int(arc4random_uniform(5) + 1)
        cell.roundedBackground.backgroundColor = colors[randomIndex]
        cell.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        cell.postLabel.text = "Anectdotes from the Smith household"
        cell.postLabel.sizeToFit()
        return cell
    }
    
}

extension HueboardsViewController: HueboardsLayoutDelegate {
    
    
    
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        return 180
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        return 60
    }
    
}

