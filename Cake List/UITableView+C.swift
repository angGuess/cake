//
//  UITableView+C.swift
//  Cake List
//
//  Created by Angelo Gkiata on 19/01/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import Foundation

import Foundation
import UIKit

extension UITableView {
    func register<T : UITableViewCell>(cell: T.Type) {
        let className = String(describing: T.self)
        register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
    }
    
    func dequeue<T : UITableViewCell>(cell: T.Type, indexPath: IndexPath) -> T {
        let className = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: className, for: indexPath) as! T
    }
}
