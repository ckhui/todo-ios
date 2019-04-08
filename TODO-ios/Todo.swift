//
//  Todo.swift
//  TODO-ios
//
//  Created by CKH on 08/04/2019.
//  Copyright © 2019 CKH. All rights reserved.
//

import Foundation

class Todo {
    var title: String
    var isCheck: Bool

    init(title: String, isCheck: Bool) {
        self.title = title
        self.isCheck = isCheck
    }

    func changeCheckStatus(_ b: Bool) {
        self.isCheck = b
    }
}
