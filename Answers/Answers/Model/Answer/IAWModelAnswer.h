//
//  IAWModelAnswer.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 28/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWModelObject.h"



@interface IAWModelAnswer : IAWModelObject

@property (strong, nonatomic, readonly) NSString *questionText;
@property (strong, nonatomic, readonly) NSSet *options;

+ (instancetype)createAnswerWithText:(NSString *)text
                             options:(NSSet *)options
                         inDatastore:(id<IAWPersistenceDatastoreProtocol>)datastore
                               error:(NSError **)error;

@end
