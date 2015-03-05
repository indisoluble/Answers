//
//  UITableViewCell+ControllerQuestionsCell.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 05/03/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
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
