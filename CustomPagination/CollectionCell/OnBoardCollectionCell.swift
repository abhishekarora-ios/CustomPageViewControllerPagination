//
//  OnBoardCollectionCell.swift
//  dineout
//
//  Created by Abhishek Arora on 17/09/19.
//  Copyright © 2019 TIL. All rights reserved.
//

import UIKit

class OnBoardCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgViewOnboard: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupData(onBoardDetails:OnBoardDetails?) {
        if let onBoardSetailModel = onBoardDetails, let imageName = onBoardSetailModel.image {
            imgViewOnboard.image = UIImage(named: imageName)

        }
    }

}
