//
//  CakeViewModel.swift
//  Cake List
//
//  Created by Angelo Gkiata on 19/01/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import Foundation
@objcMembers
class CakeViewModel: NSObject {
    var cake: Cake
    
    init(cake: Cake) {
        self.cake = cake
    }
}

extension CakeViewModel {
    @objc var title: String {
        get {
            return self.cake.title ?? "N/A"
        }
    }
    
    @objc var desc: String {
        get {
           return self.cake.desc ?? "N/A"
        }
    }
    
    @objc var safeUrl: String {
        get {
            return self.cake.image ?? "https://via.placeholder.com/100"
        }
    }
}

