//
//  ViewController.swift
//  Core Data Example
//
//  Created by A Dark Matter Creation Linder on 12/20/16.
//  Copyright © 2016 A Dark Matter Creation. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var usernameOutlet: UITextField!
    @IBOutlet var passwordOutlet: UITextField!
    @IBOutlet var alertLabelOutlet: UILabel!
    
    var context: NSManagedObjectContext? = nil
    
    @IBAction func loginAction(_ sender: Any) {
        
        alertLabelOutlet.text = logIn(username: usernameOutlet.text!, password: passwordOutlet.text!, context: context!)
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        
        alertLabelOutlet.text = signUp(username: usernameOutlet.text!, password: passwordOutlet.text!, context: context!)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        context = appDelegate.persistentContainer.viewContext
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logIn(username: String, password: String, context: NSManagedObjectContext) -> String {
        var alertText = ""
        var usernameresult = ""
        var passwordresult = ""
    
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.predicate = NSPredicate(format: "username = %@", username)
        request.predicate = NSPredicate(format: "password = %@", password)

        request.returnsObjectsAsFaults = false
    
        do {
    
            let results = try context.fetch(request)
    
            if results.count > 0 {
    
                for result in results as! [NSManagedObject]{
                if let username = result.value(forKey: "username") as? String{
                    
                    usernameresult = username
    
                    }
                    if let password = result.value(forKey: "password") as? String{
                        
                        passwordresult = password
                        
                    }
                    
                    alertText = "Username \(usernameresult) \n Password \(passwordresult) \n Login Succesful"

                }
                
    
            }else {
                
                alertText = "Invalid Login"
                
            }
    
        }catch{
            
            alertText = "Couldn't get results"
    
        }
        
        usernameOutlet.text = ""
        passwordOutlet.text = ""
    
        return alertText
    
    }

    func signUp(username: String, password: String, context: NSManagedObjectContext) -> String {
        
        var alertText = ""
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        
        newUser.setValue(username, forKey: "username")
        newUser.setValue(password, forKey: "password")
        
        do {
            
            try context.save()
            
            alertText = "Saved Successfully"
            
        }catch{
            
            alertText = "Error Saving"
            
        }
        
        usernameOutlet.text = ""
        passwordOutlet.text = ""
        
        return alertText
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }

}

