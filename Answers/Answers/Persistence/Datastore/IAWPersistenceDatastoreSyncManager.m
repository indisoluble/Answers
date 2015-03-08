//
//  IAWPersistenceDatastoreSyncManager.m
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

#import "IAWPersistenceDatastoreSyncManager.h"

#import "IAWLog.h"



@interface IAWPersistenceDatastoreSyncManager ()

@property (strong, nonatomic) NSMutableArray *jobStack;

@end



@implementation IAWPersistenceDatastoreSyncManager

#pragma mark - Init object
- (id)init
{
    self = [super init];
    if (self)
    {
        _jobStack = [NSMutableArray array];
    }
    
    return self;
}


#pragma mark - Public methods
- (void)queueSynchronizationJob:(IAWPersistenceDatastoreSyncJob *)syncJob
{
    if ([self isStackEmpty])
    {
        [self addJobToStack:syncJob];
        
        [self startFirstJob];
    }
    else
    {
        [self addJobToStack:syncJob];
    }
}


#pragma mark - Private methods
- (void)startFirstJob
{
    IAWPersistenceDatastoreSyncJob *firstJob = [self firstJobInStack];
    if (!firstJob)
    {
        IAWLogDebug(@"No more jobs in the stack");
        
        return;
    }
    
    __weak IAWPersistenceDatastoreSyncManager *wealSelf = self;
    [firstJob startWithCompletionHandler:^{
        __strong IAWPersistenceDatastoreSyncManager *strongSelf = wealSelf;
        if (strongSelf)
        {
            [strongSelf removeFirstJobFromStack];
            
            [strongSelf startFirstJob];
        }
    }];
}

- (BOOL)isStackEmpty
{
    return ([self.jobStack count] == 0);
}

- (void)addJobToStack:(IAWPersistenceDatastoreSyncJob *)job
{
    [self.jobStack addObject:job];
}

- (IAWPersistenceDatastoreSyncJob *)firstJobInStack
{
    return [self.jobStack firstObject];
}

- (void)removeFirstJobFromStack
{
    if (![self isStackEmpty])
    {
        [self.jobStack removeObjectAtIndex:0];
    }
}


#pragma mark - Public class methods
+ (instancetype)synchronizationManager
{
    return [[[self class] alloc] init];
}

@end
