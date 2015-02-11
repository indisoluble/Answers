//
//  IAWPersistenceDatastoreReplicatorDummy.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 10/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWPersistenceDatastoreReplicatorProtocol.h"



typedef void (^iawPersistenceDatastoreReplicatorDummyCompletionHandlerType)(BOOL success, NSError *error);



extern NSString * const kIAWPersistenceDatastoreReplicatorDummyErrorDomain;
extern NSInteger const kIAWPersistenceDatastoreReplicatorDummyErrorCode;



@interface IAWPersistenceDatastoreReplicatorDummy : NSObject <IAWPersistenceDatastoreReplicatorProtocol>

- (id)initWithCompletionHandler:(iawPersistenceDatastoreReplicatorDummyCompletionHandlerType)blockOrNil;

+ (instancetype)replicatorWithCompletionHandler:(iawPersistenceDatastoreReplicatorDummyCompletionHandlerType)blockOrNil;

@end
