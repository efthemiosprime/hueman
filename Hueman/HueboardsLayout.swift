//
//  HueboardsLayout.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/12/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

protocol HueboardsLayoutDelegate {
    
//    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
//    
//    
//    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
//    
    func collectionView(collectionView: UICollectionView, titleHeightAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
    
    func collectionView(collectionView: UICollectionView, coverImageHeightAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
    
    func collectionView(collectionView: UICollectionView, profileImageHeightAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
    
    func collectionView(collectionView: UICollectionView, annotationHeightAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
}

class HueboardsLayoutAttributes: UICollectionViewLayoutAttributes {
    var coverImageHeight: CGFloat = 0
    var cellHeight: CGFloat = 0
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as! HueboardsLayoutAttributes
        copy.cellHeight = cellHeight
        return copy
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let attributes = object as? HueboardsLayoutAttributes {
            if attributes.cellHeight == cellHeight {
                return super.isEqual(object)
            }
        }
        return false
    }
}

class HueboardsLayout: UICollectionViewLayout {

    // keeps reference to the delegate
    var delegate: HueboardsLayoutDelegate!

    // two public properties for configuring the layout: number of columns and cell padding
    var cellPadding: CGFloat = 0
    var numberOfColumns = 1
    
    // calculated attributes. when prepareLayout() you calculate the attributes of all items
    // add them to the cache
    private var cache = [HueboardsLayoutAttributes]()
    
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        get {
            let insets = collectionView!.contentInset
            return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
        }
    }
    
    override class func layoutAttributesClass() -> AnyClass {
        return HueboardsLayoutAttributes.self
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepareLayout() {
        if cache.isEmpty {
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            
            var xOffsets = [CGFloat]()
            for column in 0..<numberOfColumns {
                xOffsets.append(CGFloat(column) * columnWidth)
            }
            
            var yOffsets = [CGFloat](count: numberOfColumns, repeatedValue: 0)
            
            var column = 0
            for item in 0..<collectionView!.numberOfItemsInSection(0) {
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                
                let width = columnWidth - (cellPadding * 2)
                
                
                let coverImageHeight = delegate.collectionView(collectionView!, coverImageHeightAtIndexPath: indexPath, withWidth: 162)
                
                let profileImageHeight = delegate.collectionView(collectionView!, profileImageHeightAtIndexPath: indexPath, withWidth: 44)
                
                let titleHeight = delegate.collectionView(collectionView!, titleHeightAtIndexPath: indexPath, withWidth: 162)
                
                let annotationHeight = delegate.collectionView(collectionView!, annotationHeightAtIndexPath: indexPath, withWidth: width)


                let height = cellPadding + coverImageHeight + profileImageHeight + titleHeight + (annotationHeight + 15)  + cellPadding
                
     
                let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
                
                let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
                let attributes = HueboardsLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = insetFrame
                attributes.coverImageHeight = 20
                
                cache.append(attributes)
                contentHeight = max(contentHeight, CGRectGetMaxY(frame))
                yOffsets[column] = yOffsets[column] + height
            
                column = (column + 1) % numberOfColumns
             ///   column = column >= (numberOfColumns - 1) ? 0 : column += 1
                    
                
            }
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
}
