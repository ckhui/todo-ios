//
//  ViewController.swift
//  TODO-ios
//
//  Created by CKH on 08/04/2019.
//  Copyright © 2019 CKH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var todos : [Todo] = []

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
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
            self.todos.append(item)
            self.tableView.reloadData()
        }) { (err) in
            self.alert(err)
        }
    }
}

extension ViewController : UITableViewDataSource {
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
}

extension ViewController : TodoTableViewCellDelegate {
    func didChangeCheckStatus(index: IndexPath, item: Todo) {
        APIRouter.share.editTodoCompleteState(id: item.id, isCheck: item.isCheck, success: { (todo) in
            //success
            print("Backend: \(todo.isCheck) : \(todo.title)")
            print("Store: \(item.isCheck) : \(item.title)")
        }) { (err) in
            self.alert(err)
        }

    }

    
}



