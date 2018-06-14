//
//  Cat.swift
//  CatViewer
//
//  Created by Joshua Stephenson on 6/14/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

struct CatImage: Codable {
    let image: URL
}

class CatService: NSObject {
    var serviceURL: URL
    var completionBlock: (UIImage?) -> Void
    
    init(serviceURL: URL, completionBlock: @escaping (UIImage?) -> Void){
        self.serviceURL = serviceURL
        self.completionBlock = completionBlock
    }
    
    func downloadCat(){
        retrieveJSON()
    }
    
    private func retrieveJSON() {
        let request = URLRequest(url: self.serviceURL)
        let session = URLSession(configuration: .default)
        let task = session.downloadTask(with: request) { (localFileURL, response, error) in
            if let jsonFileURL = localFileURL, error == nil {
                self.parseJSON(jsonFile: jsonFileURL)
            }else { //failure
                print("Error downloading cat URL")
            }
            DispatchQueue.main.async {
                
            }
        }
        task.resume()
    }
    
    private func parseJSON(jsonFile: URL) {
        var jsonString:String?
        do {
            jsonString = try String(contentsOf: jsonFile)
        }catch{
            print("Failed getting string of json \(error.localizedDescription)")
        }
        print("json string \(jsonString!)")
        
        if let jsonString = jsonString {
            let jsonData = jsonString.data(using: .utf8)
            let decoder = JSONDecoder()
            var catImage: CatImage?
            
            do {
                catImage = try decoder.decode(CatImage.self, from: jsonData!)
                retrieveImage(imageURL: catImage!.image)
            }catch{
                catImage = nil
                print("failed decoding json: \(error.localizedDescription)")
                self.handleCompletionBlock(image: nil)
            }
        }
    }
    
    private func retrieveImage(imageURL: URL){
        let request = URLRequest(url: imageURL)
        let session = URLSession(configuration: .default)
        let task = session.downloadTask(with: request) { (localFileURL, response, error) in
            var image: UIImage?
            if let localFileURL = localFileURL, let imageData = NSData(contentsOf: localFileURL), error == nil {
                image = UIImage(data: imageData as Data)
            }else { //failure
                print("Error downloading cat")
            }
            self.handleCompletionBlock(image: image)
        }
        task.resume()
    }
    
    private func handleCompletionBlock(image: UIImage?){
        DispatchQueue.main.async {
            self.completionBlock(image)
        }
    }
}
