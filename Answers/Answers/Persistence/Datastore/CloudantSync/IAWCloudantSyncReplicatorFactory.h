//
//  IAWCloudantSyncReplicatorFactory.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 10/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudantSync.h>

#import "IAWPersistenceDatastoreReplicatorFactoryProtocol.h"



@interface IAWCloudantSyncReplicatorFactory : NSObject <IAWPersistenceDatastoreReplicatorFactoryProtocol>

- (id)initWithCloudantFactory:(CDTReplicatorFactory *)cloudantReplicatorFactory
                    datastore:(CDTDatastore *)cloudantDatastore
                          url:(NSURL *)cloudantURL;

+ (instancetype)factoryWithCloudantFactory:(CDTReplicatorFactory *)cloudantReplicatorFactory
                                 datastore:(CDTDatastore *)cloudantDatastore
                                       url:(NSURL *)cloudantURL;

@end
