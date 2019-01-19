//
//  MasterViewModel.swift
//  Cake List
//
//  Created by Angelo Gkiata on 19/01/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import UIKit
let endpoint = "https://gist.githubusercontent.com/hart88/198f29ec5114a3ec3460/raw/8dd19a88f9b8d24c23d9960f3300d0c917a4f07c/cake.json"

@objcMembers
class MasterViewModel: NSObject {
    var title = "Cake List"
    var webService: WebService
    var viewModels: [CakeViewModel]?
    
    init(webService: WebService, completion: @escaping () -> Void) {
        self.webService = webService
        super.init()
        self.webService.performURLSession(codableType: [Cake].self, endpoint: endpoint) { [weak self] (response, error) in
            if let list = response {
                self?.viewModels = list.map({ return CakeViewModel(cake: $0)})
            }
            completion()
        }
    }
}

extension MasterViewModel {
    @objc var itemCount: Int {
        get {
            return self.viewModels?.count ?? 0
        }
    }
    
    var errorMessage: String {
        get {
            return "Sorry there were no cakes available!"
        }
    }
}
