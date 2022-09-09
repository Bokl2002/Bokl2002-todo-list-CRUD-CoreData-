//
//  ViewController.swift
//  todo list project
//
//  Created by Abdullah Elbokl on 04/08/2022.
//

import UIKit
import CoreData

class TodoListViewController: UIViewController {
    
    // global vars
    var todoDatabase: [todoCellModel] = []
    
    // outlets
    @IBOutlet weak var todoListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        todoListTableView.dataSource = self
        todoListTableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(addTheNewTask), name: NSNotification.Name("newTaskAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editToDo), name: NSNotification.Name("editedTask"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteToDo), name: NSNotification.Name("deleteToDo"), object: nil)
        
        todoDatabase = cdCRUD.todosInCoredata()
    }
    
    // functions
    @objc func addTheNewTask(myNewTodo: Notification){
        if let addNew = myNewTodo.userInfo?["addedToDo"] as? todoCellModel{
            todoDatabase.append(addNew)
            todoListTableView.reloadData()
        }
    }
    @objc func editToDo(myEditToDo: Notification){
        if let editCurrent = myEditToDo.userInfo?["editedToDo"] as? todoCellModel{
            if let idx = myEditToDo.userInfo?["idx"] as? Int {
                todoDatabase[idx] = editCurrent
                todoListTableView.reloadData()
            }
        }
    }
    @objc func deleteToDo(deleteIdx: Notification){
        if let idx = deleteIdx.userInfo?["deleteIdx"] as? Int{
            todoDatabase.remove(at: idx)
            todoListTableView.reloadData()
        }
    }
    
}

extension TodoListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoDatabase.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todocell") as! todoTableViewCell
        let idx = indexPath.row
        cell.todoNamelabelView.text = todoDatabase[idx].todoName
        cell.todoDateLabelView.text = todoDatabase[idx].todoDate
        cell.todoImageView.image = todoDatabase[idx].todoImage
        cell.todoImageView.layer.cornerRadius = cell.todoImageView.frame.width / 2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let targetVC = storyboard?.instantiateViewController(withIdentifier: "detailsVC") as! detailsViewController
        
        targetVC.idx = indexPath.row
        targetVC.detailsObject = todoDatabase[indexPath.row]
        
        navigationController?.pushViewController(targetVC, animated: true)
    }
    
}

