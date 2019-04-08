//
//  Helper.swift
//  TODO-ios
//
//  Created by CKH on 09/04/2019.
//  Copyright © 2019 CKH. All rights reserved.
//

import Foundation
import UIKit


extension ViewController {
    func alert(_ title: String?, msg message: String? = nil, okHandler: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let ok = UIAlertAction(title: "OK", style: .default, handler: okHandler)

        alert.addAction(ok)
        self.present(alert, animated: true, completion: completion)
    }
}
