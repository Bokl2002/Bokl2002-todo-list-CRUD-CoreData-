//
//  detailsViewController.swift
//  todo list project
//
//  Created by Abdullah Elbokl on 04/08/2022.
//

import UIKit
import CoreData

class detailsViewController: UIViewController {

    // global vars
    var detailsObject: todoCellModel!
    var idx: Int!
    
    // outlets
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsTitleLabelView: UILabel!
    @IBOutlet weak var detailsContentLabelView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        detailsTitleLabelView.text = detailsObject.todoName
        detailsContentLabelView.text = detailsObject.todoDetails
        detailsImageView.image = detailsObject.todoImage
        
        NotificationCenter.default.addObserver(self, selector: #selector(editDetails), name: NSNotification.Name("editedTask"), object: nil)
        
    }
    
    // actions
    @IBAction func editButton(_ sender: Any) {
        let goToEditVC = (storyboard?.instantiateViewController(withIdentifier: "editVC")) as? AddEditTodoViewController
        if let goToEdit = goToEditVC{
            goToEdit.isEdit = true
            goToEdit.editToDoData = todoCellModel(todoName: detailsTitleLabelView.text!, todoImage: detailsImageView.image, todoDetails: detailsContentLabelView.text ?? "")
            goToEdit.idx = self.idx
            navigationController?.pushViewController(goToEdit, animated: true)
        }
    }
    
    // functions
    @objc func editDetails(noti: Notification){
        if let x = noti.userInfo?["editedToDo"] as? todoCellModel{
            detailsTitleLabelView.text = x.todoName
            detailsContentLabelView.text = x.todoDetails
            detailsImageView.image = x.todoImage
        }
    }
    

    
}
