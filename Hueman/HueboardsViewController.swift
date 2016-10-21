//
//  HueboardsViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/4/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class HueboardsViewController: UICollectionViewController {
    
    var colors = [UIColor]()
    var hueboards = [Hueboard]()
    
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
        
        let juliusBoard = Hueboard(title: "Puppy Love", coverImage: "hulyo.jpg", annotation: "For puppy lovers, by puppy lovers", ownerName: "Julius Busa", ownerImage: "hulyo.jpg")
        let vinBoard = Hueboard(title: "Entrepeneurship 101", coverImage: "hulyo.jpg", annotation: "Blueprints for a success startup.", ownerName: "Maverick Shawn Aquino", ownerImage: "hulyo.jpg")
        let camilleBoard = Hueboard(title: "Food Glorious Food", coverImage: "hulyo.jpg", annotation: "Have trieds and must eats.", ownerName: "Camille Laurente", ownerImage: "hulyo.jpg")
        let bongBoard = Hueboard(title: "Food Glorious Food", coverImage: "hulyo.jpg", annotation: "The boys band together to stand up for their rights. The boys band together to stand up for their rights.", ownerName: "Efthemios Suyat", ownerImage: "hulyo.jpg")
        
        let nikkiBoard = Hueboard(title: "The Smiths", coverImage: "hulyo.jpg", annotation: "Anectdotes from the Smith household.", ownerName: "Nicole Onate", ownerImage: "hulyo.jpg")
        
        let ericboard = Hueboard(title: "Lorem Ipsum", coverImage: "hulyo.jpg", annotation: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", ownerName: "Eric Cartman", ownerImage: "hulyo.jpg")
        
        let bongBoard2 = Hueboard(title: "Food Glorious Food", coverImage: "hulyo.jpg", annotation: "The boys band together to stand up for their rights. The boys band together to stand up for their rights.", ownerName: "Efthemios Suyat", ownerImage: "hulyo.jpg")
        
        hueboards.append(juliusBoard)
        hueboards.append(vinBoard)
        hueboards.append(camilleBoard)
        hueboards.append(bongBoard)
        hueboards.append(nikkiBoard)
        hueboards.append(ericboard)
        hueboards.append(bongBoard2)


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
        return hueboards.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HueboardCell", forIndexPath: indexPath) as! HueboardCell
        let randomIndex = Int(arc4random_uniform(5) + 1)
        cell.roundedBackground.backgroundColor = colors[randomIndex]
        cell.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        
        cell.hueboard = hueboards[indexPath.item]

        return cell
    }
    
   // func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndex)
    
}

extension HueboardsViewController: HueboardsLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, titleHeightAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        if let titleText = hueboards[indexPath.item].title {
            let rect = NSString(string: titleText).boundingRectWithSize(CGSizeMake(view.frame.width, 1000), options: NSStringDrawingOptions.UsesFontLeading.union(NSStringDrawingOptions.UsesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "SofiaProRegular", size: 16)!], context: nil)
            
            return rect.height + 15
        }
        
        
        return 31
        
    }
    
    func collectionView(collectionView: UICollectionView, coverImageHeightAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        return 145
    }
    
    func collectionView(collectionView: UICollectionView, profileImageHeightAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        return 48
    }
    
    func collectionView(collectionView: UICollectionView, annotationHeightAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        
        if let annotationText = hueboards[indexPath.item].annotation {
            let rect = NSString(string: annotationText).boundingRectWithSize(CGSizeMake(view.frame.width, 1000), options: NSStringDrawingOptions.UsesFontLeading.union(NSStringDrawingOptions.UsesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "SofiaProRegular", size: 14)!], context: nil)
            
            return rect.height + 6
            
        }
        
        return 20
    }
}
    
//    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
//        //let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HueboardCell", forIndexPath: indexPath) as! HueboardCell
//
//     //   let cell = collectionView.cellForItemAtIndexPath(indexPath) as! HueboardCell
//       // print("contentHeight \(collectionView.)"  )
//        return 180
//    }
//    
//    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
//        return 60
//    }
    
