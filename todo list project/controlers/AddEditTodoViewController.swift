//
//  AddNewTaskViewController.swift
//  todo list project
//
//  Created by Abdullah Elbokl on 05/08/2022.
//

import UIKit
import CoreData
import CDAlertView

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
            todoImage.image = UIImage(named: "defaultjpeg")//jpeg photo
        }

    }
    
    // actions
    @IBAction func addEditTaskButton(_ sender: Any) {
        storeNewData()
        editingOrAdding()
        addEditAlerts()
    }
    @IBAction func deleteToDo(_ sender: Any) {
        deleteAlerts()
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

    func cleaR(){
        taskTitleTextField.text = ""
        taskDetailsTextField.text = ""
    }
    
    func storeNewData(){
        newToDo = todoCellModel(todoName: taskTitleTextField.text!, todoImage: self.todoImage.image, todoDetails: taskDetailsTextField.text ?? "")
    }
    
    func editingOrAdding(){
        if !isEdit{ // if you want to add not to edit
            NotificationCenter.default.post(Notification(name: Notification.Name("newTaskAdded"), userInfo: ["addedToDo":newToDo!]))
            cdCRUD.addToCoredata(newToDo)
        }else{
            NotificationCenter.default.post(Notification(name: Notification.Name("editedTask"), userInfo: ["editedToDo":newToDo!, "idx":self.idx!]))
            // edit core data
            let temp = todoCellModel(todoName: taskTitleTextField.text!, todoImage: todoImage.image, todoDetails: taskDetailsTextField.text!)
            cdCRUD.editInCoredata(idx: self.idx, todoData: temp)
        }
    }
    
    func addEditAlerts(){
        var alert = CDAlertView(title: "Done", message: "Todo added", type: .success)
        if isEdit{
            alert = CDAlertView(title: "Done", message: "Todo edited", type: .success)
        }
        let action = CDAlertViewAction(title: "Go to main"){_ in
            if self.isEdit{
                self.navigationController?.popToRootViewController(animated: true)
            }else{
                self.tabBarController?.selectedIndex = 0
            }
            return true
        }
        alert.add(action: action)
        let doneAction = CDAlertViewAction(title: "Done"){_ in
            self.cleaR()
            return true
        }
        alert.add(action: doneAction)
        alert.show()
    }
    
    func deleteAlerts(){
        let alert = CDAlertView(title: "Warning", message: "Are you sure to delete this item ?", type: .warning)
        let cancelAction = CDAlertViewAction(title: "cancel")
        alert.add(action: cancelAction)
        let deleteAction = CDAlertViewAction(title: "Delete", textColor: .red){_ in
            NotificationCenter.default.post(Notification(name: Notification.Name("deleteToDo"), userInfo: ["deleteIdx": self.idx!]))
            cdCRUD.deleteFromCoredata(self.idx)
            self.navigationController?.popToRootViewController(animated: true)
            return true
        }
        alert.add(action: deleteAction)
        alert.show()
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
