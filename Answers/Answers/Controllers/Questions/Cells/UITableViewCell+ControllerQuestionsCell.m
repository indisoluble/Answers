//
//  UITableViewCell+ControllerQuestionsCell.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 05/03/2015.
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

#import "UITableViewCell+ControllerQuestionsCell.h"



NSString * const kIAWControllerQuestionsTVCCellID = @"QuestionCell";



@implementation UITableViewCell (ControllerQuestionsCell)

# pragma mark - Public methods
- (void)configureWithQuestion:(IAWModelQuestion *)question
               inIndexManager:(id<IAWPersistenceDatastoreIndexManagerProtocol>)indexManager
{
    // Main text
    self.textLabel.text = question.questionText;
    
    // Detail text
    NSArray *allAnswers = [IAWModelAnswer allAnswersWithText:question.questionText
                                              inIndexManager:indexManager];
    NSUInteger count = [allAnswers count];
    
    NSString *detailText = [NSString stringWithFormat:
                            @"%lu %@",
                            (unsigned long)count,
                            (count == 1 ?
                             NSLocalizedString(@"answer", @"answer") :
                             NSLocalizedString(@"answers", @"answers"))];
    self.detailTextLabel.text = detailText;
}

@end