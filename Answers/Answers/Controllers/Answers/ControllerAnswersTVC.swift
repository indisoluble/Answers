//
//  ControllerAnswersTVC.swift
//  Answers
//
//  Created by Enrique de la Torre (dev) on 04/04/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//  Unless required by applicable law or agreed to in writing, software distributed under the
//  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
//  either express or implied. See the License for the specific language governing permissions
//  and limitations under the License.
//

import UIKit



class ControllerAnswersTVC: UITableViewController
{
    // MARK: - Properties
    
    private var question: IAWModelQuestion?
    private var datastore: IAWPersistenceDatastoreProtocol?
    
    
    // MARK: - Memory management
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar
        // for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let addAnswerTVC = segue.destinationViewController as? IAWControllerAddAnswerTVC
        {
            addAnswerTVC.useQuestion(question, inDatastore: datastore)
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return 0
    }
    
    override func tableView (tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        // #warning Incomplete method implementation.
        
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier",
            forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        
        return cell
    }
    
    
    // MARK: - Public methods
    
    func useQuestion(question: IAWModelQuestion,
        inDatastore datastore: IAWPersistenceDatastoreProtocol)
    {
        self.question = question
        self.datastore = datastore
    }
}
