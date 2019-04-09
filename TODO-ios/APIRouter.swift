//
//  APIRouter.swift
//  TODO-ios
//
//  Created by CKH on 08/04/2019.
//  Copyright © 2019 CKH. All rights reserved.
//

import Foundation
import Alamofire

class APIRouter: NSObject {
    static let share = APIRouter()

    var afManager : Alamofire.Session?

    override init() {
        super.init()
        afManager = Alamofire.Session.default
    }

    func getAll(
        success: (([Todo]) -> ())? = nil,
        fail: ((_ error: String?) -> ())? = nil
        ) {
        afManager?.request(Endpoint.getAll).responseJSON(completionHandler: { (res) in
            if let err = res.error?.localizedDescription {
                fail?(err)
                return
            }

            guard let json = res.value as? [[String: Any]]
                else {
                    fail?("Invalid Response")
                    return
            }

            let todos = json.compactMap{ Todo(json: $0)}
            success?(todos)
        })
    }

    func addTodo(
        title: String,
        success: ((Todo) -> ())? = nil,
        fail: ((_ error: String?) -> ())? = nil
        ) {
        afManager?.request(Endpoint.create(title: title)).responseJSON(completionHandler: { (res) in
            if let err = res.error?.localizedDescription {
                fail?(err)
                return
            }

            guard let json = res.value as? [String: Any]
                else {
                    fail?("Invalid Response")
                    return
            }

            guard let todo = Todo(json: json)
                else {
                    fail?("No Todo Response")
                    return
            }
            success?(todo)
        })
    }

    func editTodoTitle(
        id: Int,
        title: String,
        success: ((Todo) -> ())? = nil,
        fail: ((_ error: String?) -> ())? = nil
        ) {
        afManager?.request(Endpoint.changeTitle(id: id, title: title)).responseJSON(completionHandler: { (res) in
            if let err = res.error?.localizedDescription {
                fail?(err)
                return
            }

            guard let json = res.value as? [String: Any]
                else {
                    fail?("Invalid Response")
                    return
            }

            guard let todo = Todo(json: json)
                else {
                    fail?("No Todo Response")
                    return
            }
            success?(todo)
        })
    }

    func editTodoCompleteState(
        id: Int,
        isCheck: Bool,
        success: ((Todo) -> ())? = nil,
        fail: ((_ error: String?) -> ())? = nil
        ) {
        afManager?.request(Endpoint.changeCompleted(id: id, completed: isCheck)).responseJSON(completionHandler: { (res) in
            if let err = res.error?.localizedDescription {
                fail?(err)
                return
            }

            guard let json = res.value as? [String: Any]
                else {
                    fail?("Invalid Response")
                    return
            }

            guard let todo = Todo(json: json)
                else {
                    fail?("No Todo Response")
                    return
            }
            success?(todo)
        })
    }

    func deleteTodo(
        id: Int,
        success: (() -> ())? = nil,
        fail: ((_ error: String?) -> ())? = nil
        ) {
        afManager?.request(Endpoint.delete(id: id)).responseJSON(completionHandler: { (res) in
            if let err = res.error?.localizedDescription {
                fail?(err)
                return
            }

            if res.response?.statusCode != 204 {
                fail?("Invalid Response")
            } else {
                success?()
            }
        })
    }

}

enum Endpoint: URLRequestConvertible {
    static let baseURLString = "http://127.0.0.1:8000/api/v1/"

    case getAll
    case create(title: String)
    case changeTitle(id: Int, title: String)
    case changeCompleted(id: Int, completed: Bool)
    case delete(id: Int)
    case events

    var path: String {
        switch self {
        case .getAll:
            return "task/"
        case .create:
            return "task/"
        case .changeTitle(let id, _):
            return "task/\(id)/"
        case .changeCompleted(let id, _):
            return "task/\(id)/"
        case .delete(let id):
            return "task/\(id)/"
        case .events:
            return "events/"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getAll:
            return .get
        case .create:
            return .post
        case .changeTitle:
            return .put
        case .changeCompleted:
            return .put
        case .delete:
            return .delete
        case .events:
            return .get
        }
    }
    var params: Parameters {
        switch self {
        case .getAll, .delete:
            return [:]
        case .create(let title):
            return ["title": title]
        case .changeTitle(_, let title):
            return ["title": title]
        case .changeCompleted(_, let completed):
            let bool = completed == true ? "True" : "False"
            return ["completed": bool]
        case .events:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try Endpoint.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.timeoutInterval = 5
        urlRequest.httpMethod = method.rawValue
        urlRequest = try URLEncoding.default.encode(urlRequest, with: self.params)

        if case Endpoint.events = self {
            urlRequest.addValue("text/event-stream", forHTTPHeaderField: "Content-Type")
        }
        return urlRequest
    }
}

