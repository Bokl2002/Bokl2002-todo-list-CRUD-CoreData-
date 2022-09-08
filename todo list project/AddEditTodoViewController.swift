//
//  AddNewTaskViewController.swift
//  todo list project
//
//  Created by Abdullah Elbokl on 05/08/2022.
//

import UIKit
import CoreData

class AddEditTodoViewController: UIViewController{
    
    // global vars
    var isEdit = false
    var editToDoData: todoCellModel?
    var idx: Int!
    var newToDo: todoCellModel!
    var alert: UIAlertController!
    
    // outlets
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDetailsTextField: UITextView!
    @IBOutlet weak var addEditButton: UIButton!
    @IBOutlet weak var todoImage: UIImageView!
    @IBOutlet weak var deleteToDoBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isEdit{
            perpare2Edit()
        }else{
            deleteToDoBTN.isHidden = true
        }

        
    }
    
    
    // actions
    @IBAction func addEditTaskButton(_ sender: Any) {
        storeNewData()
        if !isEdit{ // if you want to add not to edit
            NotificationCenter.default.post(Notification(name: Notification.Name("newTaskAdded"), userInfo: ["addedToDo":newToDo!]))
            addToCoredata()
        }else{
            NotificationCenter.default.post(Notification(name: Notification.Name("editedTask"), userInfo: ["editedToDo":newToDo!, "idx":self.idx!]))
            editInCoredata()
        }
        addAlerts()
    }
   
    @IBAction func deleteToDo(_ sender: Any) {
        let alert = UIAlertController(title: "Warning", message: "Are you sure to delete this item ?", preferredStyle: .alert)
        let sureDelete = UIAlertAction(title: "Delete", style: .destructive){_ in
            NotificationCenter.default.post(Notification(name: Notification.Name("deleteToDo"), userInfo: ["deleteIdx": self.idx!]))
            self.deleteFromCoredata()
            self.navigationController?.popToRootViewController(animated: true)
        }
        let cancelAlert = UIAlertAction(title: "cancel", style: .default)
        alert.addAction(sureDelete)
        alert.addAction(cancelAlert)
        present(alert, animated: true)
    }
  
    @IBAction func chooseImageBTN(_ sender: Any) {
        chooseImageGalary()
    }
   
    // functions
    func perpare2Edit(){
        navigationItem.title = "Edit ToDo"
        addEditButton.setTitle("edit", for: .normal)
        taskTitleTextField.text = editToDoData?.todoName
        taskDetailsTextField.text = editToDoData?.todoDetails
        todoImage.image = editToDoData?.todoImage
        deleteToDoBTN.isHidden = false
    }
  
    func addToCoredata(){
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "Todos", in: Context) else {return}
        let todo = NSManagedObject.init(entity: todoEntity, insertInto: Context)
        todo.setValue(newToDo.todoName, forKey: "todoName")
        todo.setValue(newToDo.todoDate, forKey: "todoDate")
        if let temp = newToDo.todoImage{
            let img = temp.jpegData(compressionQuality: 0.8)
            todo.setValue(img, forKey: "todoImage")
        }
        todo.setValue(newToDo.todoDetails, forKey: "todoDetails")
        do {
            try Context.save()
            print("Done")
        } catch {
            print(error)
        }
    }
    
    func editInCoredata(){
        let FR: NSFetchRequest<Todos> = Todos.fetchRequest()
        FR.returnsObjectsAsFaults = false
        do {
            let result = try Context.fetch(FR) as [NSManagedObject]
            result[idx].setValue(taskTitleTextField.text, forKey: "todoName")
            result[idx].setValue(taskDetailsTextField.text, forKey: "todoDetails")
//            result[idx].setValue(<#T##Any?#>, forKey: "todoDate")
            if let temp = todoImage.image{
                let img = temp.jpegData(compressionQuality: 0.8)
                result[idx].setValue(img, forKey: "todoImage")
            }
            try Context.save()
        } catch {
            print(error)
        }
    }
    
    func deleteFromCoredata(){
        let FR: NSFetchRequest<Todos> = Todos.fetchRequest()
        do {
            let result = try Context.fetch(FR) as [NSManagedObject]
            Context.delete(result[idx])
            try Context.save()
        } catch  {
            print(error)
        }
    }
    
    func cleaR(){
        taskTitleTextField.text = ""
        taskDetailsTextField.text = ""
    }
    
    func addAlerts(){
        //stay here alert
        alert = UIAlertController(title: "Done", message: "ToDo added", preferredStyle: UIAlertController.Style.alert)
        if isEdit{
            alert.message = "ToDo edited"
        }
        let stayHereAlertAction = UIAlertAction(title: "stay here", style: UIAlertAction.Style.default) { _ in
            self.cleaR()
        }
        var goBack: UIAlertAction!
        if isEdit{
            goBack = UIAlertAction(title: "Go Back", style: .default){_ in
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            goBack = UIAlertAction(title: "Go To Main", style: .default){_ in
                self.tabBarController?.selectedIndex = 0
            }
        }
        alert.addAction(goBack)
        alert.addAction(stayHereAlertAction)
        present(alert, animated: true) {
            //
        }
        
    }
    
    func storeNewData(){
        newToDo = todoCellModel(todoName: taskTitleTextField.text!, todoImage: self.todoImage.image, todoDetails: taskDetailsTextField.text ?? "")

    }
    
}

// choose image from gallary
extension AddEditTodoViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func chooseImageGalary(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let im = info[.editedImage] as? UIImage{
            todoImage.image = im
        }
    }
}
