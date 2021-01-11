//
//  ViewController.swift
//  inputLogin
//
//  Created by Bagus setiawan on 11/06/20.
//  Copyright © 2020 Bagus setiawan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    struct User {
        var username = ""
        var email = ""
        var pass = ""
    }
    
    var arrayUser = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func createData()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "Users", in: managedContext)!
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(usernameTextField.text, forKey: "username")
        user.setValue(emailTextField.text, forKey: "email")
        user.setValue(passwordTextField.text, forKey: "password")
        
        do{
            try managedContext.save()
        } catch let error as NSError{
            print("could not save.\(error),\(error.userInfo)")
        }
    }
    
    func retrieveData(){
        //Refer NSPersistentContainer for AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Creating new entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        arrayUser = []
        //Fetching
        do{
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject]{
                
                var temp = User()
                temp.username = data.value(forKey: "username") as! String
                temp.email = data.value(forKey: "email") as! String
                temp.pass = data.value(forKey: "password") as! String
                
                arrayUser.append(temp)
                print(data.value(forKey: "username") as! String)
                print(data.value(forKey: "email") as! String)
                print(data.value(forKey: "password") as! String)
                print(data.objectID)
                //print(arrayOfUser)
            }
            print(arrayUser)
        } catch {
            print("failed")
        }
    }
    
    func updateData(){
        //Refer NSPersistentContainer for AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Users")
        fetchRequest.predicate = NSPredicate(format: "username = %@", usernameTextField.text!)
        do {
            let test = try managedContext.fetch(fetchRequest)
            
                let objectUpdate = test[0] as! NSManagedObject
               
            objectUpdate.setValue("\(emailTextField.text!)", forKey: "email")
                objectUpdate.setValue("\(passwordTextField.text!)", forKey: "password")
            do {
                try managedContext.save()
            }
            catch{
                print(error)
            }
        }
        catch{
            print(error)
        }
    }
    
    func deleteData(){
        //Refer NSPersistentContainer for AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Users")
        fetchRequest.predicate = NSPredicate(format: "username = %@", usernameTextField.text!)
        do {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            do {
                try managedContext.save()
            }
            catch{
                print(error)
            }
        }
        catch{
            print(error)
        }
    }
    
    @IBAction func register(_ sender: Any) {
        createData()
    }
    @IBAction func read(_ sender: Any) {
        retrieveData()
    }
    @IBAction func update(_ sender: Any) {
        updateData()
    }
    @IBAction func deletebtn(_ sender: Any) {
        deleteData()
    }
    
    
    

}

