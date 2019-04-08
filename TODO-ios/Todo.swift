//
//  Todo.swift
//  TODO-ios
//
//  Created by CKH on 08/04/2019.
//  Copyright © 2019 CKH. All rights reserved.
//

import Foundation

class Todo {
    var id: Int
    var title: String
    var isCheck: Bool

    init(id: Int, title: String, isCheck: Bool) {
        self.id = id
        self.title = title
        self.isCheck = isCheck
    }

    convenience init?(json: [String: Any]) {
        guard
            let id = json["id"] as? Int,
            let title = json["title"] as? String,
            let isCheck = json["completed"] as? Bool
            else { return nil}
        self.init(id: id, title: title, isCheck: isCheck)
    }

    func changeCheckStatus(_ b: Bool) {
        self.isCheck = b
    }
}
