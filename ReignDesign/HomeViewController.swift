//
//  HomeViewController.swift
//  ReignDesign
//
//  Created by admin on 10/18/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import PKHUD
import MGSwipeTableCell

class HomeViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    
    @IBOutlet weak var tableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var urlShow : String = ""
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        HUD.show(.progress)
        
        if Utils.isConnectedToNetwork(){
            ServiceCall.getData{ (result: Any?) in
                if let storiesResult = result as? JSONWebService{
                    
                    for story in storiesResult.hits{
                        
                        if !self.appDelegate.removeItems.contains(story.story_id){
                            self.appDelegate.stories.append(story)
                        }
                    }
                    
                    self.tableView.reloadData()
                    HUD.hide()
                }else{
                    HUD.hide()
                    let alert = Utils.makeSimpleAlert(title: "Problemas al traer datos", subtitle: "Problemas de comunicación remoto")
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else{
            HUD.hide()
            let alert = Utils.makeSimpleAlert(title: "Problemas al traer datos", subtitle: "No hay conexión a Internet")
            
            self.present(alert, animated: true, completion: nil)
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(HomeViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //reload data
    @objc func refresh(_ sender: Any) {
        
        HUD.show(.progress)
        
        if Utils.isConnectedToNetwork(){
            ServiceCall.getData{ (result: Any?) in
                if let storiesResult = result as? JSONWebService{
                    
                    self.appDelegate.stories = []
                    
                    for story in storiesResult.hits{
                        
                        if !self.appDelegate.removeItems.contains(story.story_id){
                            self.appDelegate.stories.append(story)
                        }
                    }
                    
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    HUD.hide()
                }else{
                    HUD.hide()
                    self.refreshControl.endRefreshing()
                    let alert = Utils.makeSimpleAlert(title: "Problemas al traer datos", subtitle: "Problemas de comunicación remoto")
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }else{
            HUD.hide()
            self.refreshControl.endRefreshing()
            //let alert = Utils.makeSimpleAlert(title: "Problemas al traer datos", subtitle: "No hay conexión a Internet")
            
            //self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appDelegate.stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "story", for: indexPath) as! TableViewCell
        
        let story = self.appDelegate.stories[indexPath.row]
        
        if story.story_title != ""{
            cell.labelTitle.text = story.story_title
        }else{
            cell.labelTitle.text = "No_title"
        }
        
        let storyDate : Date = Utils.dateFromString(dateToFormat: story.created_at)
        
        if NSCalendar.current.isDateInToday(storyDate){
            let now = Date()
            let calendar = NSCalendar.current
            let components = calendar.dateComponents([.hour, .minute], from: storyDate, to: now)
            
            if components.hour! > 1{
                let hours : String = components.hour!.description
                cell.labelAuthor.text = story.author + " - " + hours + "h"
            }else{
                let minutes : String = components.minute!.description
                cell.labelAuthor.text = story.author + " - " + minutes + "m"
                
            }
            
        }else if NSCalendar.current.isDateInYesterday(storyDate){
            cell.labelAuthor.text = story.author + " - Yesterday"
        }else{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from:storyDate)
            cell.labelAuthor.text = story.author + " - \(dateString)"
            
        }
        
        
        cell.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: .red) {
            (sender: MGSwipeTableCell!) -> Bool in
            self.appDelegate.removeItems.append(story.story_id)
            self.appDelegate.stories.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            return true}]
        
        cell.leftSwipeSettings.transition = .rotate3D
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = self.appDelegate.stories[indexPath.row]
        
        if story.url != ""{
            self.urlShow = story.url
            self.performSegue(withIdentifier: "showWebView", sender: self)
        }else if story.story_url != ""{
            self.urlShow = story.story_url
            self.performSegue(withIdentifier: "showWebView", sender: self)
        }else{
            let alert = Utils.makeSimpleAlert(title: "Sorry !!", subtitle: "Can not open article, does not have url")
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showWebView"{
            if let destinationVC = segue.destination as? WebViewController {
                destinationVC.urlShow = self.urlShow
            }
        }
    }
    
}


    
