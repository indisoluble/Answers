//
//  IAWPersistenceDatastoreSyncJob.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 08/02/2015.
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

#import "IAWPersistenceDatastoreSyncJob.h"

#import "IAWLog.h"



@interface IAWPersistenceDatastoreSyncJob () <IAWPersistenceDatastoreReplicatorDelegate>

@property (strong, nonatomic) id<IAWPersistenceDatastoreReplicatorProtocol> replicator;

@property (copy, nonatomic) iawPersistenceDatastoreSyncJobCompletionHandlerBlockType completionHandler;

@property (assign, nonatomic) BOOL alreadyStarted;

@end



@implementation IAWPersistenceDatastoreSyncJob

#pragma mark - Init object
- (id)init
{
    return [self initWithReplicator:nil];
}

- (id)initWithReplicator:(id<IAWPersistenceDatastoreReplicatorProtocol>)replicator
{
    self = [super init];
    if (self)
    {
        if (!replicator)
        {
            self = nil;
        }
        else
        {
            _replicator = replicator;
            _replicator.delegate = self;
            
            _completionHandler = nil;
            
            _alreadyStarted = NO;
        }
    }
    
    return self;
}


#pragma mark - IAWPersistenceDatastoreReplicatorDelegate methods
- (void)datastoreReplicatorDidFinish:(id<IAWPersistenceDatastoreReplicatorProtocol>)repicator
{
    IAWLogDebug(@"Synchronization finished");
    
    self.completionHandler();
    
    self.completionHandler = nil;
}


#pragma mark - Public methods
- (void)startWithCompletionHandler:(iawPersistenceDatastoreSyncJobCompletionHandlerBlockType)completionHandler
{
    if (self.alreadyStarted)
    {
        IAWLogError(@"A replicator can not be re-used");
        
        [IAWPersistenceDatastoreSyncJob dispatchBlockToMainThread:^{
            completionHandler();
        }];
        
        return;
    }
    
    self.alreadyStarted = YES;
    
    self.completionHandler = completionHandler;
    
    NSError *error = nil;
    if (![self.replicator startWithError:&error])
    {
        IAWLogError(@"Replicator could not be started: %@", error);
        
        self.completionHandler = nil;
        
        [IAWPersistenceDatastoreSyncJob dispatchBlockToMainThread:^{
            completionHandler();
        }];
    }
}


#pragma mark - Public class methods
+ (instancetype)syncJobWithReplicator:(id<IAWPersistenceDatastoreReplicatorProtocol>)replicator
{
    return [[[self class] alloc] initWithReplicator:replicator];
}


#pragma mark - Private class methods
+ (void)dispatchBlockToMainThread:(void(^)(void))block
{
    dispatch_async(dispatch_get_main_queue(), block);
}

@end
