//
//  AACardFlowLayout.swift
//  Created by Abhishek Arora on 18/09/19.
//  Copyright © 2019 TIL. All rights reserved.
//

import UIKit

class AACardFlowLayout: UICollectionViewFlowLayout {
    var currentIndex: Int = 0
    var flickVelocity:CGFloat?
    
    override init() {
        super.init()
        self.addObserver(self, forKeyPath: "collectionView.contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCardWidth() -> CGFloat {
        return self.itemSize.width + self.minimumLineSpacing
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var propContentOffset = proposedContentOffset
        let rawIndex = (self.collectionView?.contentOffset.x)!/self.getCardWidth()
        let nextIndex = (velocity.x > 0.0) ? ceil(rawIndex):floor(rawIndex)
        let pannedLessThanACard = abs(1 + CGFloat(currentIndex) - rawIndex) > 0.5
        self.flickVelocity = 0
        if let flickVel = self.flickVelocity {
            let flicked = Int(abs(velocity.x)) > Int(flickVel)
            if pannedLessThanACard && flicked {
                propContentOffset.x = nextIndex*self.getCardWidth()
            }else {
                propContentOffset.x = round(rawIndex) * self.getCardWidth()
            }
        }
        
        return propContentOffset
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (keyPath == "collectionView.contentOffset") {
            let newIndex = Int(round(Double(self.collectionView!.contentOffset.x / getCardWidth())))
            if currentIndex != newIndex {
                currentIndex = newIndex
            }
        }
    }

    deinit {
        removeObserver(self, forKeyPath: "collectionView.contentOffset")
    }
}
