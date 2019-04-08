//
//  TodoTableViewCell.swift
//  TODO-ios
//
//  Created by CKH on 08/04/2019.
//  Copyright © 2019 CKH. All rights reserved.
//

import UIKit

protocol TodoTableViewCellDelegate {
    func didChangeCheckStatus(index: IndexPath, item: Todo)
}

class TodoTableViewCell: UITableViewCell {
    static let identifier = "TodoTableViewCell"


    @IBOutlet weak var checkBox: UIButtonCheckBox!
    @IBOutlet weak var label: UITextField!



    var todoItem : Todo = Todo(id: 0, title: "", isCheck: false)
    var index : IndexPath = IndexPath(item: 0, section: 0)
    var delegate: TodoTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkBox.delegate = self
        label.isEnabled = false
    }

    func setup(item: Todo, index: IndexPath){
        todoItem = item
        self.label.text = item.title
        self.checkBox.isCheck = item.isCheck
    }

}

extension TodoTableViewCell: UIButtonCheckBoxDelegate {
    func didChangeCheckStatus(isCheck: Bool, button: UIButtonCheckBox) {
        todoItem.changeCheckStatus(isCheck)
        delegate?.didChangeCheckStatus(index: index, item: todoItem)
    }
}
