//
//  Content+CoreDataProperties.swift
//  NhatKy
//
//  Created by Lê Hoàng Sinh on 6/21/20.
//  Copyright © 2020 Lê Hoàng Sinh. All rights reserved.
//
//

import Foundation
import CoreData


extension Content {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Content> {
        return NSFetchRequest<Content>(entityName: "Content")
    }

    @NSManaged public var name: String?
    @NSManaged public var soLuong: Int
    
    static func insertContent (name:String,soLuong: Int) -> Content? { // Thêm một bản ghi vào core data
        /*
         Tạo một bản ghi mới
         truyền vào 1: Tên thực thể
         truyền vào 2: Đối tượng có kiểu ManagedObjectContext để thao tác với các bản ghi
         **/
        let newContent = NSEntityDescription.insertNewObject(forEntityName: "Content", into: AppDelegate.managedObjectContex!) as! Content
        newContent.name = name
        newContent.soLuong = soLuong
        
        do {
            try AppDelegate.managedObjectContex?.save() //Lưu lại sự thay đổi
        } catch  {
            print("Insert failed")
            return nil
        }
        return newContent
    }
    
    static func deleteContent (item:Content) -> Bool { //Xoá 1 bản ghi trong core data
        AppDelegate.managedObjectContex?.delete(item) // Sử dụng hàm xoá của ManagedObjectContext
        do {
            try AppDelegate.managedObjectContex?.save() // Lưu lại thay đổi
        } catch  {
            return false
        }
        return true
    }
    
    static func updateContent (item: Content, name: String, soLuong: Int) -> Content{ // Cập nhật 1 bản ghi trong core data
        item.name = name
        item.soLuong = soLuong
        do {
            try AppDelegate.managedObjectContex?.save() // Lưu lại thay đổi
        } catch  {
            print("update failed")
        }
                
        return item
    }
    
    static func lookContent (key: String, pro: String) -> [Content] { // Tìm kiếm trong core data
        var result = [Content]()    // tạo mảng chứa để chứa các bản ghi sau khi tìm kiếm
        let fetchR:NSFetchRequest = Content.fetchRequest()  // sử dụng NSFetchRequest để lấy tất cả các bản ghi trong core data
        let predicate = NSPredicate(format: "\(pro) contains %@", key) // sử dụng NSPredicate để tạo điều kiện tìm kiếm
        fetchR.predicate = predicate // thêm điều kiện tìm kiếm vào trong fetch
//        var subPredicates = [NSPredicate]()
//        subPredicates.append(predicate)
//        if subPredicates.count > 0 {
//            let compoundPredicates = NSCompoundPredicate.init(type: .and, subpredicates: subPredicates)
//            fetchR.predicate = compoundPredicates
//        }
        
        do{
            //thực hiện tìm kiếm và hiển thị bằng hàm fetch()
            result = try AppDelegate.managedObjectContex?.fetch(fetchR) as! [Content]
        }catch{
            print("look failed")
        }
        return result
    }
    
    static func sort(pro: String) -> [Content]{ // sắp xếp
        var result = [Content]() //tạo mảng chưa kết quả
        let fetchRequest:NSFetchRequest = Content.fetchRequest() //lấy tất cả bản ghi
        let sort = [NSSortDescriptor(key: "\(pro)", ascending: true)] // sử dụng NSSortDescriptor để tạo điều kiện sắp xếp
        fetchRequest.sortDescriptors = sort // thêm điều kiện sắp xếp vào fetch
        do {
            //thực hiện sắp xếp bằng và hiển thị bằng hàm fetch()
            try result = AppDelegate.managedObjectContex?.fetch(fetchRequest) as! [Content]
        } catch  {
            print("sort failed")
        }
        return result
    }
}

    
