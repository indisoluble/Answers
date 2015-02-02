//
//  IAWPersistenceDatastoreDecorator.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 02/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWPersistenceDatastoreProtocol.h"
#import "IAWPersistenceDatastoreNotificationCenter.h"



@interface IAWPersistenceDatastoreDecorator : NSObject <IAWPersistenceDatastoreProtocol>

@property (strong, nonatomic, readonly) IAWPersistenceDatastoreNotificationCenter *notificationCenter;

- (id)initWithDatastore:(id<IAWPersistenceDatastoreProtocol>)datastoreOrNil
     notificationCenter:(IAWPersistenceDatastoreNotificationCenter *)notificationCenterOrNil;

+ (instancetype)datastore;

@end
