//
//  TodoDetailViewController.swift
//  Image Search
//
//  Created by 高橋健太 on 2015/06/18.
//  Copyright (c) 2015年 高橋健太. All rights reserved.
//

import UIKit
import CoreData

class TodoDetailViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var textField: UITextField!
    
    
    // 検索機能で使うURL
    let frontsearchUrl = "https://www.google.co.jp/search?q="
    var backsearchUrl = "&tbm=isch&safe=strict"
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var todo: Todos?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.textField.delegate = self
        
        if todo != nil {
            self.textField.text = todo?.content
            if let beforeSearchText = textField.text {
                let spaceSearchText = beforeSearchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                let replaceSearchText = spaceSearchText.stringByReplacingOccurrencesOfString(" ", withString: "+")
                let url = frontsearchUrl + replaceSearchText + backsearchUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                openUrl(url)
                textField.resignFirstResponder()
            }

        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func dismissViewController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Error", message: "Content is empty!", preferredStyle: .Alert)
        let dafaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(dafaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func checkContentAndSave() {
        var error: NSError?
        if !managedObjectContext!.save(&error) {
            showAlert()
            managedObjectContext!.rollback()
        }
    }
    
    func createTodo() {
        let entity = NSEntityDescription.entityForName("Todos", inManagedObjectContext: managedObjectContext!)
        let todo = Todos(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        todo.content = self.textField.text
        self.checkContentAndSave()
    }
    
    func editTodo() {
        todo?.content = self.textField.text
        self.checkContentAndSave()
    }
    //文字列で指定されたURLをWebViewで開く。
    func openUrl(urlString: String){
        let url = NSURL(string: urlString)
        let urlRequest = NSURLRequest(URL: url!)
        webView.loadRequest(urlRequest)
    }
    
    @IBAction func save(sender: AnyObject) {
        if todo != nil {
            self.editTodo()
        } else {
            self.createTodo()
        }
        self.dismissViewController()
    }

    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewController()
        
    }

    @IBAction func tapTextField(sender: UITextField) {
        // MARK: - UISearchBarDelegate
            if let beforeSearchText = textField.text {
                let spaceSearchText = beforeSearchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                let replaceSearchText = spaceSearchText.stringByReplacingOccurrencesOfString(" ", withString: "+")
                let url = frontsearchUrl + replaceSearchText + backsearchUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                openUrl(url)
                textField.resignFirstResponder()
            }
        }
        
    @IBAction func SafeMode(sender: AnyObject) {
        backsearchUrl = "&tbm=isch"
        
    }


        
    }

    
    
    

