//
//  IAWCloudantSyncReplicatorFactory.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 07/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <CloudantSync.h>



@interface IAWCloudantSyncReplicatorFactory : NSObject

+ (CDTReplicator *)pushReplicatorWithManager:(CDTDatastoreManager *)manager
                                      source:(CDTDatastore *)datastore
                                      target:(NSURL *)remoteDatabaseURL;

@end
