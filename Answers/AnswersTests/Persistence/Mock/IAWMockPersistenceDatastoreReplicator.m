//
//  IAWMockPersistenceDatastoreReplicator.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 08/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWMockPersistenceDatastoreReplicator.h"



@interface IAWMockPersistenceDatastoreReplicator ()

@end



@implementation IAWMockPersistenceDatastoreReplicator

#pragma mark - Synthesize properties
@synthesize delegate = _delegate;


#pragma mark - IAWPersistenceDatastoreReplicatorProtocol methods
- (BOOL)startWithError:(NSError **)error
{
    if (self.resultStart)
    {
        [self asyncNotifyReplicationResult];
    }
    else if (error)
    {
        *error = self.resultStartError;
    }
    
    return self.resultStart;
}


#pragma mark - Private methods
- (void)asyncNotifyReplicationResult
{
    __weak IAWMockPersistenceDatastoreReplicator *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong IAWMockPersistenceDatastoreReplicator *strongSelf = weakSelf;
        if (strongSelf && strongSelf.delegate)
        {
            if (strongSelf.resultReplication)
            {
                [strongSelf.delegate datastoreReplicatorDidComplete:strongSelf];
            }
            else
            {
                [strongSelf.delegate datastoreReplicator:strongSelf didFailWithError:strongSelf.resultReplicationError];
            }
        }
    });
}

@end
