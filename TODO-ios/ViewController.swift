//
//  ViewController.swift
//  TODO-ios
//
//  Created by CKH on 08/04/2019.
//  Copyright © 2019 CKH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.estimatedRowHeight = 65
            tableView.rowHeight = UITableView.automaticDimension
            tableView.allowsSelection = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier, for: indexPath) as? TodoTableViewCell
            else { return UITableViewCell() }

        let t = Todo(title: "item \(indexPath.row)", isCheck: false)
        cell.delegate = self
        cell.setup(item: t, index: indexPath)
        return cell
    }
}

extension ViewController : TodoTableViewCellDelegate {
    func didChangeCheckStatus(index: IndexPath, item: Todo) {
        print("\(item.isCheck) : \(item.title)")
    }

    
}



