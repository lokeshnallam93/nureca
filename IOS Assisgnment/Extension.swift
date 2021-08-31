//
//  Extension.swift
//  IOS Assisgnment
//
//  Created by Lokesh on 29/08/21.
//

import Foundation
import UIKit
//MARK:-TableView With Reuse
 extension UITableView {

    func register(cellType: UITableViewCell.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }

    func register(cellTypes: [UITableViewCell.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }

    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type) -> T {

        return self.dequeueReusableCell(withIdentifier: type.className) as? T ?? T.init()
    }

    // Indexpath
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as? T ?? T.init()
    }

    

}
//NSOBject: Class
public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}

public extension NSObjectProtocol {
    var describedProperty: String {
        let mirror = Mirror(reflecting: self)
        return mirror.children.map { element -> String in
            let key = element.label ?? "Unknown"
            let value = element.value
            return "\(key): \(value)"
            }
            .joined(separator: "\n")
    }
}
