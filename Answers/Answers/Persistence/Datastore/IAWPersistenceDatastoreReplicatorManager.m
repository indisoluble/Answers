//
//  IAWPersistenceDatastoreReplicatorManager.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 07/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWPersistenceDatastoreReplicatorManager.h"

#import "IAWLog.h"



@interface IAWPersistenceDatastoreReplicatorManager ()

@property (strong, nonatomic) NSMutableArray *replicatorStack;

@end



@implementation IAWPersistenceDatastoreReplicatorManager

#pragma mark - Init object
- (id)init
{
    self = [super init];
    if (self)
    {
        _replicatorStack = [NSMutableArray array];
    }
    
    return self;
}


#pragma mark - Public methods
- (void)queueReplicator:(id<IAWPersistenceDatastoreReplicatorProtocol>)replicator
{
    if ([self isStackEmpty])
    {
        [self addReplicatorToStack:replicator];
        
        [self startFirstReplicator];
    }
    else
    {
        [self addReplicatorToStack:replicator];
    }
}


#pragma mark - Private methods
- (void)startFirstReplicator
{
    id<IAWPersistenceDatastoreReplicatorProtocol> firstReplicator = [self firstReplicatorInStack];
    if (!firstReplicator)
    {
        IAWLogDebug(@"No more repicators in the stack");
        
        return;
    }
    
    __weak IAWPersistenceDatastoreReplicatorManager *wealSelf = self;
    [firstReplicator startWithCompletionHandler:^{
        __strong IAWPersistenceDatastoreReplicatorManager *strongSelf = wealSelf;
        if (strongSelf)
        {
            [strongSelf removeFirstReplicatorFromStack];
            
            [strongSelf startFirstReplicator];
        }
    }];
}

- (BOOL)isStackEmpty
{
    return ([self.replicatorStack count] == 0);
}

- (void)addReplicatorToStack:(id<IAWPersistenceDatastoreReplicatorProtocol>)replicator
{
    [self.replicatorStack addObject:replicator];
}

- (id<IAWPersistenceDatastoreReplicatorProtocol>)firstReplicatorInStack
{
    return [self.replicatorStack firstObject];
}

- (void)removeFirstReplicatorFromStack
{
    if (![self isStackEmpty])
    {
        [self.replicatorStack removeObjectAtIndex:0];
    }
}


#pragma mark - Public class methods
+ (instancetype)replicatorManager
{
    return [[[self class] alloc] init];
}

@end
