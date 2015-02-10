//
//  IAWPersistenceDatastore.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 06/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWPersistenceDatastoreNotificationCenter.h"

#import "IAWPersistenceDocumentProtocol.h"



@interface IAWPersistenceDatastore : NSObject

@property (strong, nonatomic, readonly) IAWPersistenceDatastoreNotificationCenter *notificationCenter;

- (BOOL)createDocument:(id<IAWPersistenceDocumentProtocol>)document error:(NSError **)error;
- (BOOL)refreshDocuments;
- (NSArray *)allDocuments;

+ (instancetype)datastore;

@end
