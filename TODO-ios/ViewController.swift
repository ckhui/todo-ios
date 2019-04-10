//
//  ViewController.swift
//  TODO-ios
//
//  Created by CKH on 08/04/2019.
//  Copyright © 2019 CKH. All rights reserved.
//

import UIKit
import EventSource

class ViewController: UIViewController {

    var todos : [Todo] = []
    let eventSource: EventSource =  EventSource(url: Endpoint.sseURL)

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.estimatedRowHeight = 65
            tableView.rowHeight = UITableView.automaticDimension
            tableView.allowsSelection = false
        }
    }
    @IBOutlet weak var inputTextFiled: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        APIRouter.share.getAll(success: { (todos) in
            self.todos = todos
            self.tableView.reloadData()
        }) { (err) in
            self.alert(err)
        }

        setupSSE()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eventSource.close()
    }


    func setupSSE(){
        eventSource.onOpen({ (event) in
            print("Open Connection")
        })

        eventSource.onError { (error) in
            self.alert(error?.description)
        }

        eventSource.onMessage { (event) in
            guard let e = event
                else { return }
            let todoEvent = TodoEvent(e)
            guard let t = todoEvent.todo
            else { return }

            switch (todoEvent.type) {
            case "new":
                self.todos.append(t)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case "edit":
                guard let i = self.todos.firstIndex(where: { (item) -> Bool in
                    item.id == t.id
                })
                    else { return }
                self.todos[i] = t
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [IndexPath(item: i, section: 0)], with: .fade)
                }
            case "delete":
                guard let i = self.todos.firstIndex(where: { (item) -> Bool in
                    item.id == t.id
                })
                    else { return }
                self.todos.remove(at: i)
                DispatchQueue.main.async {
                    self.tableView.deleteRows(at: [IndexPath(item: i, section: 0)], with: .left)
                }
            default:
                return
            }


        }
    }


    @IBAction func addButtonClick(_ sender: Any) {
        guard let text = inputTextFiled.text,
              text.count > 0
            else {
                alert("Input cannot be empty")
                return
        }
        APIRouter.share.addTodo(title: text, success: { (item) in
            self.inputTextFiled.text = ""
//            self.todos.append(item)
//            self.tableView.reloadData()
        }) { (err) in
            self.alert(err)
        }
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier, for: indexPath) as? TodoTableViewCell
            else { return UITableViewCell() }

        let t = todos[indexPath.row]
        cell.delegate = self
        cell.setup(item: t, index: indexPath)
        return cell
    }


    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let t = todos[indexPath.row]
            APIRouter.share.deleteTodo(id: t.id, success: {
//                self.todos.remove(at: indexPath.row)
//                self.tableView.deleteRows(at: [indexPath], with: .left)
            }) { (err) in
                self.alert(err)
            }
        }
    }
}

extension ViewController : TodoTableViewCellDelegate {
    func didChangeCheckStatus(index: IndexPath, item: Todo) {
        APIRouter.share.editTodoCompleteState(id: item.id, isCheck: item.isCheck, success: { (todo) in
//            //success
//            print("Backend: \(todo.isCheck) : \(todo.title)")
//            print("Store: \(item.isCheck) : \(item.title)")
        }) { (err) in
            self.alert(err)
        }

    }

    
}
