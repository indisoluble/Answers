//
//  IAWPersistenceDatastoreSyncManager.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 07/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWPersistenceDatastoreSyncJob.h"



@interface IAWPersistenceDatastoreSyncManager : NSObject

- (void)queueSynchronizationJob:(IAWPersistenceDatastoreSyncJob *)syncJob;

+ (instancetype)synchronizationManager;

@end
