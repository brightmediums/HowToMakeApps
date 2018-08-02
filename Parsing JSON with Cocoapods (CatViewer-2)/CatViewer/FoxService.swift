//
//  AnimalService.swift
//  CatViewer
//
//  Created by Joshua Stephenson on 6/14/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class FoxService: NSObject {

    var serviceURL: String
    var completionHandler: (UIImage?) -> Void
    
    init(serviceURL: String, completionHandler: @escaping (UIImage?) -> Void){
        self.serviceURL = serviceURL
        self.completionHandler = completionHandler
    }
    
    func download() {
        retrieveJSON()
    }
    
    private func retrieveJSON() {
        Alamofire.request(self.serviceURL).responseJSON { (response) in
            if let jsonString = response.result.value {
                let json = JSON(jsonString)
                self.retrieveImage(imageURL: json["image"].stringValue)
            }else{
                self.executeCompletionHandler(image: nil)
            }
        }
    }
    
    private func retrieveImage(imageURL: String) {
        print("retrieving image: \(imageURL)")
        Alamofire.request(imageURL).responseImage { (response) in
            self.executeCompletionHandler(image: response.result.value)
        }
    }
    
    private func executeCompletionHandler(image: UIImage?) {
        DispatchQueue.main.async {
            self.completionHandler(image)
        }
    }
}
