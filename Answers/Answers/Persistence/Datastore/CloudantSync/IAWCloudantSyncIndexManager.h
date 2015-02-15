//
//  IAWCloudantSyncIndexManager.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 15/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudantSync.h>

#import "IAWPersistenceDatastoreIndexManagerProtocol.h"



@interface IAWCloudantSyncIndexManager : NSObject <IAWPersistenceDatastoreIndexManagerProtocol>

- (id)initWithIndexesForFieldNames:(NSSet *)fieldnames
                       inDatastore:(CDTDatastore *)datastore;

+ (instancetype)indexManagerWithIndexesForFieldNames:(NSSet *)fieldnames
                                         inDatastore:(CDTDatastore *)datastore;

@end
