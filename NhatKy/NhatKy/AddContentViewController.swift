//
//  AddContentViewController.swift
//  NhatKy
//
//  Created by Lê Hoàng Sinh on 6/21/20.
//  Copyright © 2020 Lê Hoàng Sinh. All rights reserved.
//

import UIKit

class AddContentViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var textViewContent: UITextView!
    @IBOutlet weak var txtSoLuong: UITextField!
    //MARK: -var
    var txtText:String = ""         // ??? biến chứa giá trị của textView ???
    var soLuong: Int = 0
    var delegate: DelegateProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        /**
        Thiết lập giá trị cho textView  =  giá trị được truyền từ TableView
         */
        textViewContent.text = txtText
    }
    //MARK: -keyboard hidden
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    //MARK: -event
    @IBAction func btnSaveClick(_ sender: Any) { // Lưu kết quả và hiển thị lên TableView
        
        if textViewContent.text.isEmpty { //Kiểm tra khi nhập
            let alert = UIAlertController(title: "Notice", message: "Please type something", preferredStyle: .alert)
            let icon = UIAlertAction.init(title: "OK", style: .default, handler: nil)
            alert.addAction(icon)
            present(alert,animated: true,completion: nil)
        }else {
            delegate?.addContent(name:  textViewContent.text!, soluong: Int(txtSoLuong.text!)!)
            self.navigationController?.popViewController(animated: true)
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
