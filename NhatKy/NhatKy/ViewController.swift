//
//  ViewController.swift
//  NhatKy
//
//  Created by Lê Hoàng Sinh on 6/21/20.
//  Copyright © 2020 Lê Hoàng Sinh. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtTim: UITextField!
    @IBOutlet var ScrollPopUp: UIScrollView!
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var txtSoLuong: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet var PanGR: UIPanGestureRecognizer!
    @IBOutlet var longPress: UILongPressGestureRecognizer!
    
    
    //MARK: -var
    var contents = [Content]()
    var tim: String!
    //MARK: - viewLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.dataSource = self
        tblView.delegate = self
        txtTim.delegate = self
        //txtTim.addTarget(self, action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)), for: UIControl.Event.editingChanged) // ???
        
        btnSave.alpha = 0 // ẩn nút Save
        btnDelete.alpha = 0 //ẩn nút Delete
        
        
        //longPress.addTarget(self, action: #selector(handleLongPress)) //???
        longPress.minimumPressDuration = 0.5 // thời gian ấn trước khi thực hiện
        self.tblView.addGestureRecognizer(longPress) // kết nối tableView với sự kiện ấn nút
        blurView.bounds = view.bounds // xác định kích thước của blurView
        blurView.center = view.center // tâm của blurView = tâm của màn hình chính
        ScrollPopUp.center = view.center // tâm của PopUpView = tâm của màn hình chính
        ScrollPopUp.bounds = CGRect(x: 0, y: 0, width: view.bounds.width * 0.9, height: view.bounds.height * 0.6) //xác đinh kích thước của popUpView
        fetchData() //Tìm kiếm và hiển thị dữ liệu lên bảng
    }
    
    //MARK: -tableView
    //Dữ liệu cho các dòng
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell //xác định cell
        cell.lblText.text = contents[indexPath.row].name //gán giá trị
        cell.lblSoLuong.text = String(contents[indexPath.row].soLuong)
        return cell
    }
    //Số dòng hiển thị
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    //Sự kiện khi 1 dòng được chọn
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let update = sb.instantiateViewController(identifier: "UpdateContent") as! UpdateContentViewController
        update.delegate = self
        self.navigationController?.pushViewController(update, animated: true)
        let content = self.contents[indexPath.row] // lấy giá trị tại dòng đang chọn
        update.txtText = content.name! // hiển thị giá trị vào textView bên AddContentView
        update.SoLuong = content.soLuong
    }
    //Sự kiện vuốt sang phải
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") // tạo nút DELETE
        {(ACTION,view,completionHandler) in             // khi ấn vào thì thực hiện hành động
            let content = self.contents[indexPath.row]  // lấy giá trị tại vị trí được chọn
            Content.deleteContent(item: content)        // xoá phần tử tại vị trí được chọn trong data core
            self.contents.remove(at: indexPath.row)     // xoá phần tử tại vị trí được trọn trong mảng contents
            tableView.deleteRows(at: [indexPath], with: .fade) // hiệu ứng khi xoá trong tableView
            //            completionHandler(false)
        }
        delete.image = UIImage(systemName: "trash") // Custom lại nút DELETE
        delete.backgroundColor = UIColor.red
        
        // Hiển thị nút DELETE
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        return swipe
    }
    //MARK: -textField
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(search), object: self)
        //        self.perform(#selector(search), with: self, afterDelay: 0.5)
        return true
    }
    @objc func search() {
        if txtTim.text?.count == 0 { //nếu ô tìm kiếm rỗng thì hiển thị tất cả dữ liệu
            fetchData()
        }else { // ngược lại thì tìm theo từ khoá
            contents = Content.lookContent(key: txtTim.text!,pro:"name" )
            self.tblView.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // Click return để ẩn bàn phím
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: -Event
    @IBAction func btnAddClick(_ sender: Any) { // Chuyển đến AddContentView
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let add = sb.instantiateViewController(identifier: "AddContent") as! AddContentViewController
        add.delegate = self
        self.navigationController?.pushViewController(add, animated: true)
    }
    
    @IBAction func btnTimClick(_ sender: Any) { // Tìm kiếm theo giá trị được nhập từ TextField,sau khi ấn nút thì mới tìm
        if txtTim.text?.count == 0 {
            fetchData()
        }else {
            contents = Content.lookContent(key: txtTim.text!,pro: "name")
            self.tblView.reloadData()
        }
    }
    @IBAction func btnSortClick(_ sender: Any) { // Sắp xếp theo name tăng dần
        contents = Content.sort(pro: "soLuong") //pro là tên thuộc tính mà cần được sắp xếp
        self.tblView.reloadData()
    }
    //    @IBAction func LongPressGR(_ sender: Any) {
    //        animateIn(view: blurView)
    //        animateIn(view: ScrollPopUp)
    //    }
    @IBAction func PanGRAction(_ sender: Any) {
        UIView.animate(withDuration: 1, animations:{ //thời gian xuất hiện nút Save và Delete
            self.btnSave.alpha = 1 //hiển thị nút Save
            self.btnDelete.alpha = 1 // hiển thị nút Delete
            self.btnSave.isHidden = false // kích hoạt nút Save
            self.btnDelete.isHidden = false // kích hoạt nút Delete
        })
    }
    
    @IBAction func ClickBlurView(_ sender: Any) { //khi ấn vào blurView thì ẩn PopUpView và BlurView
        animateOut(view: ScrollPopUp)
        animateOut(view: blurView)
    }
    @IBAction func btnSaveClick(_ sender: Any) { // khi ấn nút Save thì lưu giá trị và hiển thị tableView
        let content = Content.lookContent(key: "\(textview.text!)", pro: "name")
        Content.updateContent(item: content[0], name: textview.text, soLuong: Int(String(txtSoLuong.text!))!)
        animateOut(view: ScrollPopUp)
        animateOut(view: blurView)
        tblView.reloadData()
    }
    
    @IBAction func btnDeleteClick(_ sender: Any) { //khi ấn nút Delete thì xoá giá trị và hiển thị tableView
        let content = Content.lookContent(key: "\(textview.text!)", pro: "name")
        Content.deleteContent(item: content[0])
        animateOut(view: ScrollPopUp)
        animateOut(view: blurView)
        fetchData()
    }
    @IBAction func longPressAction(_ sender: Any) {
        let p = longPress.location(in: tblView)
        let indexPath = tblView.indexPathForRow(at: p)
        if indexPath == nil {
            
        }else if longPress.state == UILongPressGestureRecognizer.State.began {
            animateIn(view: blurView)
            animateIn(view: ScrollPopUp)
            let content = contents[indexPath!.row]
            textview.text = content.name
            txtSoLuong.text = String(content.soLuong)
        }
    }
    @IBAction func editChangeed(_ sender: Any) {
        //        textFieldShouldEndEditing(txtTim)
        self.perform(#selector(search), with: self, afterDelay: 0.5)
    }
    @IBAction func TimAction(_ sender: Any) {
        
    }
    //MARK: -funcw
    //Hiển thị dữ liệu
    @objc func fetchData() {
        do{
            contents = try AppDelegate.managedObjectContex?.fetch(Content.fetchRequest()) as! [Content]
            self.tblView.reloadData()
        }catch{
            print("show failed")
        }
    }
    func animateIn(view: UIView) { // hàm hiển thị PopUpView và BlurView khi giữ 1 dòng trong bảng
        self.view.addSubview(view) // kết nối màn hình chính với View truyền vào
        view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2) // tạo hiệu ứng phóng to
        view.alpha = 0 // ẩn View được truyền vào
        UIView.animate(withDuration: 0.3, animations: { // tạo hiệu ứng xuất hiện của View
            view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0) // đưa về kích thước ban đầu
            view.alpha = 1 // hiển thị View
        })
    }
    
    func animateOut(view: UIView) { // hàm ẩn PopUpView và BlurView khi ấn vào blurView
        UIView.animate(withDuration: 0.3, animations: { // tạo hiệu ứng ẩn PopUpView và BlurView
            view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2) // hiệu ứng phóng to
            view.alpha = 0 // ẩn View
        },completion: {
            _ in view.removeFromSuperview() //quay lại màn hình cha( màn hình trước)
        })
    }
    
    /**
     cần chú ý xác định trạng thái của longPress vì mặc đinh longPress sẽ thực hiện 3 trạng thái xuất hiện, thay đổi và kết thúc
     */
    @objc func handleLongPress(longPress: UILongPressGestureRecognizer) { //hàm thực hiện hiển thị khi ấn và giữ 1 dòng trên tableView
        //        let p = longPress.location(in: self.tblView) // vị trí nơi ấn và giữ
        //        let indexPath = self.tblView.indexPathForRow(at: p) // xác định vị trí trên tableView
        //        if indexPath == nil { // nếu dòng không có dữ liệu
        //
        //        }else if longPress.state == UIGestureRecognizer.State.began { // ngược lại xác định trạng thái của việc ấn và giữ nút
        //            animateIn(view: blurView) //hiển thị BlurView
        //            animateIn(view: ScrollPopUp) // hiển thị PopUpView
        //            let content = self.contents[indexPath!.row] // tạo biến chứa giá trị cần hiển thị lên PopUpView
        //            textview.text = content.name //hiển thị dữ liệu
        //            txtSoLuong.text = String(content.soLuong) //hiển thị dữ liệu
        //        }
    }
}
extension ViewController: DelegateProtocol {
    func addContent(name: String, soluong: Int) {
        Content.insertContent(name: name, soLuong: soluong)
        fetchData()
    }
    
    func updateContent(name: String, soluong: Int) {
        var contents = [Content]() //tạo mảng chứa kết quả
        contents = Content.lookContent(key: name ,pro: "name")
        Content.updateContent(item: contents[0], name: name,soLuong: soluong)// sửa bản ghi
        fetchData()
    }

    
    
}
