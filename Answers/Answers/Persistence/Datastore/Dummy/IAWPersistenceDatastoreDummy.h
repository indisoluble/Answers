//
//  IAWPersistenceDatastoreDummy.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 24/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWPersistenceDatastoreProtocol.h"



extern NSString * const kIAWPersistenceDatastoreDummyErrorDomain;
extern NSInteger const kIAWPersistenceDatastoreDummyErrorCode;



@interface IAWPersistenceDatastoreDummy : NSObject <IAWPersistenceDatastoreProtocol>

+ (instancetype)datastore;

@end
