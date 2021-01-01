//
//  UpdateContentViewController.swift
//  NhatKy
//
//  Created by Lê Hoàng Sinh on 6/23/20.
//  Copyright © 2020 Lê Hoàng Sinh. All rights reserved.
//

import UIKit

class UpdateContentViewController: UIViewController {
    @IBOutlet weak var textViewContent: UITextView!
    @IBOutlet weak var txtSoLuong: UITextField!
    var txtText:String = ""
    var SoLuong: Int = 0
    var delegate: DelegateProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewContent.text = txtText
        txtSoLuong.text = String(SoLuong)
        
        // Do any additional setup after loading the view.
    }

    /**
     Tìm bản ghi cần sửa với -pro là tên thuộc tính trong data core và key là giá trị nhập vào
     */
    @IBAction func btnUpdateClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.delegate?.updateContent(name: textViewContent.text, soluong: Int(String(txtSoLuong.text!))!)
    }
}
    

