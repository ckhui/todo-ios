//
//  Todo.swift
//  TODO-ios
//
//  Created by CKH on 08/04/2019.
//  Copyright © 2019 CKH. All rights reserved.
//

import Foundation
import EventSource

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
            let title = json["title"] as? String
        else { return nil}

        var isCheckBool : Bool
        if let isCheckStr = json["completed"] as? String {
            if isCheckStr == "True" {
                isCheckBool = true
            } else if isCheckStr == "False" {
                isCheckBool = false
            } else {
                return nil
            }
        } else if let isCheck = json["completed"] as? Bool {
            isCheckBool = isCheck
        } else {
            return nil
        }
        self.init(id: id, title: title, isCheck: isCheckBool)
    }

    func changeCheckStatus(_ b: Bool) {
        self.isCheck = b
    }
}


struct TodoEvent {
    var type: String
    var todo: Todo?

    init(_ e: Event) {
        self.type = e.event
        if let json =  e.data.toJson() {
            self.todo = Todo(json: json)
        }
    }
}
