//
//  UITableViewCell+ControllerQuestionsCell.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 05/03/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IAWModel.h"



extern NSString * const kIAWControllerQuestionsTVCCellID;



@interface UITableViewCell (ControllerQuestionsCell)

- (void)configureWithQuestion:(IAWModelQuestion *)question
               inIndexManager:(id<IAWPersistenceDatastoreIndexManagerProtocol>)indexManager;

@end
