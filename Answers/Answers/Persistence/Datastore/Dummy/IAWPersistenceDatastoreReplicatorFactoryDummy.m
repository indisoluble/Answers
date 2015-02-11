//
//  IAWPersistenceDatastoreReplicatorFactoryDummy.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 10/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWPersistenceDatastoreReplicatorFactoryDummy.h"

#import "IAWPersistenceDatastoreReplicatorDummy.h"



@interface IAWPersistenceDatastoreReplicatorFactoryDummy ()

@end



@implementation IAWPersistenceDatastoreReplicatorFactoryDummy

#pragma mark - IAWPersistenceDatastoreReplicatorFactoryProtocol methods
- (id<IAWPersistenceDatastoreReplicatorProtocol>)pushReplicator
{
    return [IAWPersistenceDatastoreReplicatorDummy replicatorWithCompletionHandler:nil];
}

- (id<IAWPersistenceDatastoreReplicatorProtocol>)pullReplicatorWithCompletionHandler:(iawPersistenceDatastoreReplicatorCompletionHandlerType)block
{
    return [IAWPersistenceDatastoreReplicatorDummy replicatorWithCompletionHandler:^(BOOL success, NSError *error) {
        block(success, error);
    }];
}


#pragma mark - Public class methods
+ (instancetype)factory
{
    return [[[self class] alloc] init];
}

@end
