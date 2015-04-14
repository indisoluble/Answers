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
    private var datastore: IAWPersistenceDatastoreProtocol
    private var indexManager: IAWPersistenceDatastoreIndexManagerProtocol?
    private var notificationCenter: IAWPersistenceDatastoreNotificationCenter?
    
    private var allAnswers: [IAWModelAnswer]
    
    
    // MARK: - Init object
    
    override init(style: UITableViewStyle)
    {
        self.datastore = IAWPersistenceDatastoreDummy()
        self.allAnswers = []
        
        super.init(style: style)
    }

    required init(coder aDecoder: NSCoder)
    {
        self.datastore = IAWPersistenceDatastoreDummy.datastore()
        self.allAnswers = []
        
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Memory management
    
    deinit
    {
        self.removeDatastoreObservers()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let addAnswerTVC = segue.destinationViewController as? IAWControllerAddAnswerTVC
        {
            addAnswerTVC.useQuestion(question, inDatastore: datastore)
        }
    }
    
    
    // MARK: - UITableViewDataSource methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return allAnswers.count
    }
    
    override func tableView (tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(kControllerAnswersTVCCellID,
            forIndexPath: indexPath)
            as! UITableViewCell
        
        cell.configureWithAnswer(allAnswers[indexPath.row])
        
        return cell
    }
    
    override func tableView(tableView: UITableView,
        canEditRowAtIndexPath indexPath: NSIndexPath)
        -> Bool
    {
        return true
    }
    
    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath)
    {
        let oneAnswer = allAnswers[indexPath.row]
        
        var error: NSError?
        if !IAWModelAnswer.deleteAnswer(oneAnswer, inDatastore: datastore, error: &error)
        {
            // #warning Show log
        }
    }
    
    
    // MARK: - Internal methods
    
    func useQuestion(question: IAWModelQuestion?,
        inDatastore datastore: IAWPersistenceDatastoreProtocol?,
        indexedWith indexManager: IAWPersistenceDatastoreIndexManagerProtocol?,
        listenNotificationsWith notificationCenter: IAWPersistenceDatastoreNotificationCenter?)
    {
        // Remove observers on previous datastore
        self.removeDatastoreObservers()
        
        // Update properties with new values
        self.question = question
        self.datastore = (datastore != nil ? datastore! : IAWPersistenceDatastoreDummy())
        self.indexManager = indexManager
        self.notificationCenter = notificationCenter
        
        allAnswers = ControllerAnswersTVC.allAnswersForQuestion(self.question,
            inIndexManager: self.indexManager)
        
        // Refresh UI
        title = (question != nil ?
            question!.questionText :
            NSLocalizedString("Answers", comment: "Answers"))
        
        if isViewLoaded()
        {
            tableView.reloadData()
        }
        
        // Add observers to new datastore
        self.addDatastoreObservers()
    }
    
    
    // MARK: - Private methods
    
    private func addDatastoreObservers()
    {
        if let notificationCenter = notificationCenter
        {
            notificationCenter.addDidCreateDocumentNotificationObserver(self,
                selector: "manageDidCreateDocumentNotification:",
                sender: datastore)
            notificationCenter.addDidDeleteDocumentNotificationObserver(self,
                selector: "manageDidCreateDocumentNotification:",
                sender: datastore)
        }
    }
    
    private func removeDatastoreObservers()
    {
        if let notificationCenter = notificationCenter
        {
            notificationCenter.removeDidCreateDocumentNotificationObserver(self, sender: datastore)
            notificationCenter.removeDidDeleteDocumentNotificationObserver(self, sender: datastore)
        }
    }
    
    // Next method has to be dynamic (visible to objc runtime), otherwise the app will crash when
    // NotificationCenter calls it because it is private
    dynamic private func manageDidCreateDocumentNotification(notification: NSNotification)
    {
        // #warning Show log
        
        allAnswers = ControllerAnswersTVC.allAnswersForQuestion(self.question,
            inIndexManager: self.indexManager)
        
        if isViewLoaded()
        {
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Private type methods
    private class func allAnswersForQuestion(question: IAWModelQuestion?,
        inIndexManager indexManager: IAWPersistenceDatastoreIndexManagerProtocol?)
        -> [IAWModelAnswer]
    {
        var result = [] as [IAWModelAnswer]
        
        if let question = question
        {
            if let indexManager = indexManager
            {
                result = IAWModelAnswer.allAnswersWithText(question.questionText,
                    inIndexManager: indexManager)
                    as! [IAWModelAnswer]
            }
        }
        
        return result
    }
}
