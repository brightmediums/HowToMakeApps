//
//  AsynchronousProcess.swift
//  Why You Should Use a Delegate and Protocol
//
//  Created by Joshua Stephenson on 9/13/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

protocol AsynchronousProcessDelegate {
    func asynchronousProcessDidFinish(withSuccess: Bool)
}

class AsynchronousProcess: NSObject {

    var delegate: AsynchronousProcessDelegate?
    
    func doSomething() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            self.reportBack()
        }
    }
    
    func doSomethingWithCallback(completionHandler: @escaping (Bool) -> Void){
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            completionHandler(true)
        }
    }
    
    private func reportBack() {
        self.delegate?.asynchronousProcessDidFinish(withSuccess: true)
    }
}
