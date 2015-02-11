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



@interface IAWPersistenceDatastoreReplicatorDummy ()

@end



@implementation IAWPersistenceDatastoreReplicatorDummy

#pragma mark - Synthesize properties
@synthesize delegate = _delegate;


#pragma mark - IAWPersistenceDatastoreReplicatorProtocol methods
- (BOOL)startWithError:(NSError **)error
{
    IAWLogError(@"This is a dummy replicator. It will always return error");
    
    if (error)
    {
        *error = [NSError errorWithDomain:kIAWPersistenceDatastoreReplicatorDummyErrorDomain
                                     code:IAWPERSISTENCEDATASTOREREPLICATORDUMMY_ERRORCODE
                                 userInfo:nil];
    }
    
    return NO;
}


#pragma mark - Public class methods
+ (instancetype)replicator
{
    return [[[self class] alloc] init];
}

@end
