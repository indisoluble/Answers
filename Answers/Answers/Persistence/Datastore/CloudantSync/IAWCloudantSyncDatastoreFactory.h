//
//  IAWCloudantSyncDatastoreFactory.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 07/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <CloudantSync.h>



@interface IAWCloudantSyncDatastoreFactory : NSObject

+ (CDTDatastoreManager *)datastoreManager;
+ (CDTDatastore *)datastoreWithManager:(CDTDatastoreManager *)manager;
+ (CDTReplicatorFactory *)replicatorFactoryWithManager:(CDTDatastoreManager *)manager;

@end
