//
//  UIButtonCheckBox.swift
//  TODO-ios
//
//  Created by CKH on 08/04/2019.
//  Copyright © 2019 CKH. All rights reserved.
//

import UIKit
import Foundation

protocol UIButtonCheckBoxDelegate {
    func didChangeCheckStatus(isCheck: Bool, button: UIButtonCheckBox)
}

class UIButtonCheckBox : UIButton {
    private let checkImage = UIImage(named: "check")
    var delegate: UIButtonCheckBoxDelegate?
    var isCheck : Bool = false {
        didSet {
            if isCheck {
                self.setImage(checkImage, for: .normal)
                self.backgroundColor = AppConstant.green
            } else {
                self.setImage(nil, for: .normal)
                self.backgroundColor = nil
            }
        }
    }

    override func awakeFromNib() {
        design()
        self.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        self.isCheck = false
    }

    private func design() {
        self.setTitle("", for: .normal)
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = AppConstant.green.cgColor
        self.clipsToBounds = true
        self.tintColor = UIColor.white
        self.imageView?.contentMode = ContentMode.scaleAspectFit
    }

    @objc func toggle() {
        if isCheck {
            self.isCheck = false
        } else {
            self.isCheck = true
        }
        delegate?.didChangeCheckStatus(isCheck: self.isCheck, button: self)
    }

}
