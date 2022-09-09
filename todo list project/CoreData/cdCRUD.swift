//
//  coreData-CRUD.swift
//  todo list project
//
//  Created by Abdullah Elbokl on 09/09/2022.
//

import Foundation
import UIKit
import CoreData

class cdCRUD{
    
    static func addToCoredata(_ newToDo: todoCellModel){
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "Todos", in: Context) else {return}
        let todo = NSManagedObject.init(entity: todoEntity, insertInto: Context)
        todo.setValue(newToDo.todoName, forKey: "todoName")
//        todo.setValue(newToDo.todoDate, forKey: "todoDate")
        todo.setValue(newToDo.todoDetails, forKey: "todoDetails")
        if let temp = newToDo.todoImage{
            let img = temp.jpegData(compressionQuality: 0.8)
            todo.setValue(img, forKey: "todoImage")
        }
        do {
            try Context.save()
            print("Done")
        } catch {
            print(error)
        }
    }
    
    static func deleteFromCoredata(_ idx: Int){
        let FR: NSFetchRequest<Todos> = Todos.fetchRequest()
        do {
            let result = try Context.fetch(FR) as [NSManagedObject]
            Context.delete(result[idx])
            try Context.save()
        } catch  {
            print(error)
        }
    }
    
    static func editInCoredata(idx: Int, todoData: todoCellModel){
        let FR: NSFetchRequest<Todos> = Todos.fetchRequest()
        FR.returnsObjectsAsFaults = false
        do {
            let result = try Context.fetch(FR) as [NSManagedObject]
            result[idx].setValue(todoData.todoName, forKey: "todoName")
            result[idx].setValue(todoData.todoDetails, forKey: "todoDetails")
//            result[idx].setValue(<#T##Any?#>, forKey: "todoDate")
            if let temp = todoData.todoImage{
                let img = temp.jpegData(compressionQuality: 0.8)
                result[idx].setValue(img, forKey: "todoImage")
            }
            try Context.save()
        } catch {
            print(error)
        }
    }
    
    static func todosInCoredata() -> [todoCellModel]{
        var CDTodos: [todoCellModel] = []
        let FR: NSFetchRequest<Todos> = Todos.fetchRequest()
        FR.returnsObjectsAsFaults = false
        do {
            let results = try Context.fetch(FR) as [NSManagedObject]
            for result in results{
                let todoName = result.value(forKey: "todoName") as? String
//                let todoDate = result.value(forKey: "todoDate") as? String
                var todoImage: UIImage?
                if let temp = result.value(forKey: "todoImage") as? Data{
                    let img = UIImage(data: temp)
                    todoImage = img!
                }
                let todoDetails = result.value(forKey: "todoDetails") as? String
                
                CDTodos.append(todoCellModel(todoName: todoName ?? "", todoImage: todoImage, todoDetails: todoDetails ?? ""))
            }
        } catch {
            print(error)
        }
        return CDTodos
    }
}
