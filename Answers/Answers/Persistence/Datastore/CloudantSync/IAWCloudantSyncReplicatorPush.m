//
//  IAWCloudantSyncReplicatorPush.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 07/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//  Unless required by applicable law or agreed to in writing, software distributed under the
//  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
//  either express or implied. See the License for the specific language governing permissions
//  and limitations under the License.
//

#import "IAWCloudantSyncReplicatorPush.h"

#import "IAWLog.h"



@interface IAWCloudantSyncReplicatorPush () <CDTReplicatorDelegate>

@property (strong, nonatomic, readonly) CDTReplicator *replicator;

@end



@implementation IAWCloudantSyncReplicatorPush

#pragma mark - Synthesize properties
@synthesize delegate = _delegate;


#pragma mark - Init object
- (id)init
{
    return [self initWithFactory:nil source:nil target:nil];
}

- (id)initWithFactory:(CDTReplicatorFactory *)replicatorFactory
               source:(CDTDatastore *)datastore
               target:(NSURL *)remoteDatabaseURL
{
    self = [super init];
    if (self)
    {
        CDTReplicator *thisReplicator = [IAWCloudantSyncReplicatorPush pushReplicatorWithFactory:replicatorFactory
                                                                                          source:datastore
                                                                                          target:remoteDatabaseURL];
        if (!thisReplicator)
        {
            self = nil;
        }
        else
        {
            _replicator = thisReplicator;
            _replicator.delegate = self;
        }
    }
    
    return self;
}


#pragma mark - CDTReplicatorDelegate methods
- (void)replicatorDidComplete:(CDTReplicator *)replicator
{
    IAWLogDebug(@"Replication completed");
    
    [self notifyOnMainThreadReplicatorDidFinish];
}

- (void)replicatorDidError:(CDTReplicator *)replicator info:(NSError *)info
{
    IAWLogError(@"Replication failed: %@", info);
    
    [self notifyOnMainThreadReplicatorDidFinish];
}


#pragma mark - IAWPersistenceDatastoreReplicatorProtocol methods
- (BOOL)startWithError:(NSError **)error
{
    IAWLogDebug(@"Replicator started");
    
    return [self.replicator startWithError:error];
}


#pragma mark - Private methods
- (void)notifyOnMainThreadReplicatorDidFinish
{
    __weak IAWCloudantSyncReplicatorPush *weakSelf = self;
    [IAWCloudantSyncReplicatorPush dispatchBlockToMainThread:^{
        __strong IAWCloudantSyncReplicatorPush *strongSelf = weakSelf;
        if (strongSelf)
        {
            [strongSelf notifyReplicatorDidFinish];
        }
    }];
}

- (void)notifyReplicatorDidFinish
{
    if (self.delegate)
    {
        [self.delegate datastoreReplicatorDidFinish:self];
    }
}


#pragma mark - Public class methods
+ (instancetype)replicatorWithFactory:(CDTReplicatorFactory *)replicatorFactory
                               source:(CDTDatastore *)datastore
                               target:(NSURL *)remoteDatabaseURL
{
    return [[[self class] alloc] initWithFactory:replicatorFactory source:datastore target:remoteDatabaseURL];
}


#pragma mark - Private class methods
+ (CDTReplicator *)pushReplicatorWithFactory:(CDTReplicatorFactory *)replicatorFactory
                                      source:(CDTDatastore *)datastore
                                      target:(NSURL *)remoteDatabaseURL
{
    if (!replicatorFactory || !datastore || !remoteDatabaseURL)
    {
        IAWLogError(@"All parameters are mandatory");
        
        return nil;
    }
    
    CDTPushReplication *pushReplication = [CDTPushReplication replicationWithSource:datastore
                                                                             target:remoteDatabaseURL];
    
    NSError *error = nil;
    CDTReplicator *replicator = [replicatorFactory oneWay:pushReplication error:&error];
    if (!replicator)
    {
        IAWLogError(@"Replicator not created: %@", error);
    }
    
    return replicator;
}

+ (void)dispatchBlockToMainThread:(void(^)(void))block
{
    dispatch_async(dispatch_get_main_queue(), block);
}

@end
