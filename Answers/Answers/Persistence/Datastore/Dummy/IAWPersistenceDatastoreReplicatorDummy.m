//
//  IAWPersistenceDatastoreReplicatorDummy.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 10/02/2015.
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
