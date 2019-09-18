//
//  OnBoardViewModel.swift
//  Created by Abhishek Arora on 18/09/19.
//  Copyright © 2019 TIL. All rights reserved.
//

import Foundation
import UIKit
class OnBoardingViewModel {
    var onBoardModel: OnBoardModelData?
    let rightSelectionBgColor = UIColor(red: 80/255, green: 184/1255, blue: 100/255, alpha: 1.0)
    let wrongSelectionBgColor = UIColor(red: 255/255, green: 100/255, blue: 90/255, alpha: 1.0)
    let selectionTextColor = UIColor.white
    let noSelectionTextColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    var isRightAnsTouches = false
    var isWrongAnsTouches = false
    var dictSavedState = Dictionary<String, String>()
    let wrongSelectedTxt = "wrongSelected"
    let rightSelectedTxt = "rightSelected"
    var isFirstTimeCellLoad = true
    let imageCellIdentifier = "OnBoardCollectionCell"

    func getOnBoardData(withCompletion completed:@escaping ((_ isCompleted: Bool) -> Void)) {
        let jsonResponse =  self.readDummyJsonResponse("onBoard")
        let responseResult = jsonResponse! as Dictionary<String,AnyObject>
        if let data = try? JSONSerialization.data(withJSONObject: responseResult, options: .prettyPrinted) {
            do {
                let jsonModel = try JSONDecoder().decode(OnBoardModelData.self, from: data)
                self.onBoardModel = jsonModel
                completed(true)
            } catch {
            }
        } else {
        }
    }
    
    func readDummyJsonResponse(_ fileName: String) -> [String:Any]? {
        guard let bundleFile = Bundle.main.path(forResource: fileName, ofType: "json") else{
            return nil
        }
        let data = NSData(contentsOfFile: bundleFile) as Data?
        do {
            guard let fileData = data else {
                return nil
            }
            let json = try JSONSerialization.jsonObject(with: fileData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
            return json
        }catch {
            
        }
        return nil
    }
}

struct OnBoardModelData: Codable {
    var skipButton:String?
    var onBoardDetails:[OnBoardDetails]?
    
    enum CodingKeys:String, CodingKey {
        case skipButton
        case onBoardDetails
    }
    
    init(from decoder : Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        skipButton = try values.decodeIfPresent(String.self, forKey: .skipButton)
        onBoardDetails = try values.decodeIfPresent([OnBoardDetails].self, forKey: .onBoardDetails)
    }
}

struct OnBoardDetails: Codable {
    var image: String?
    var title: String?
    var button1: String?
    var button2: String?
    
    enum CodingKeys: String,CodingKey {
        case image
        case title
        case button1
        case button2
    }
}

