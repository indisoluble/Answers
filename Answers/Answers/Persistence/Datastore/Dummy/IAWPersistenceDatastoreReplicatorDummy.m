//
//  IAWPersistenceDatastoreReplicatorDummy.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 10/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWPersistenceDatastoreReplicatorDummy.h"

#import "IAWLog.h"



NSString * const kIAWPersistenceDatastoreReplicatorDummyErrorDomain = @"kIAWPersistenceDatastoreReplicatorDummyErrorDomain";
NSInteger const kIAWPersistenceDatastoreReplicatorDummyErrorCode = 1;



@interface IAWPersistenceDatastoreReplicatorDummy ()

@property (copy, nonatomic, readonly) iawPersistenceDatastoreReplicatorDummyCompletionHandlerType blockOrNil;

@end



@implementation IAWPersistenceDatastoreReplicatorDummy

#pragma mark - Synthesize properties
@synthesize delegate = _delegate;


#pragma mark - Init object
- (id)init
{
    return [self initWithCompletionHandler:nil];
}

- (id)initWithCompletionHandler:(iawPersistenceDatastoreReplicatorDummyCompletionHandlerType)blockOrNil
{
    self = [super init];
    if (self)
    {
        _blockOrNil = (blockOrNil ? [blockOrNil copy] : nil);
    }
    
    return self;
}


#pragma mark - IAWPersistenceDatastoreReplicatorProtocol methods
- (BOOL)startWithError:(NSError **)error
{
    IAWLogError(@"This is a dummy replicator. It will always return error");
    
    NSError *thisError = [NSError errorWithDomain:kIAWPersistenceDatastoreReplicatorDummyErrorDomain
                                             code:kIAWPersistenceDatastoreReplicatorDummyErrorCode
                                         userInfo:nil];
    
    if (self.blockOrNil)
    {
        iawPersistenceDatastoreReplicatorDummyCompletionHandlerType completionHandler = self.blockOrNil;
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(NO, thisError);
        });
    }
    
    if (error)
    {
        *error = thisError;
    }
    
    return NO;
}


#pragma mark - Public class methods
+ (instancetype)replicatorWithCompletionHandler:(iawPersistenceDatastoreReplicatorDummyCompletionHandlerType)blockOrNil
{
    return [[[self class] alloc] initWithCompletionHandler:blockOrNil];
}

@end
