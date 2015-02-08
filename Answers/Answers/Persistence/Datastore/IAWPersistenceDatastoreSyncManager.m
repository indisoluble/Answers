//
//  IAWPersistenceDatastoreSyncManager.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 07/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
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
- (void)queueSynchronizationJob:(id<IAWPersistenceDatastoreSyncJobProtocol>)syncJob
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
    id<IAWPersistenceDatastoreSyncJobProtocol> firstJob = [self firstJobInStack];
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

- (void)addJobToStack:(id<IAWPersistenceDatastoreSyncJobProtocol>)job
{
    [self.jobStack addObject:job];
}

- (id<IAWPersistenceDatastoreSyncJobProtocol>)firstJobInStack
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
