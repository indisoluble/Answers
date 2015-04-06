//
//  UITableViewCell+ControllerAnswersCell.swift
//  Answers
//
//  Created by Enrique de la Torre (dev) on 05/04/2015.
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

import Foundation



let kControllerAnswersTVCCellID = "AnswerCell"



extension UITableViewCell
{
    // MARK: - Internal methods
    
    func configureWithAnswer(answer: IAWModelAnswer)
    {
        var cellText = ""
        
        var options = answer.options.allObjects as [String]
        if (!options.isEmpty)
        {
            options.sort { return $0 < $1 }
            
            cellText = options[0]
            options.removeAtIndex(0)
            
            for oneOption in options
            {
                cellText += (", " + oneOption)
            }
        }
        
        textLabel?.text = cellText
    }
}