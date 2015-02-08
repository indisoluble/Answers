//
//  IAWMockPersistenceDatastoreReplicator.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 08/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWPersistenceDatastoreReplicatorProtocol.h"



@interface IAWMockPersistenceDatastoreReplicator : NSObject <IAWPersistenceDatastoreReplicatorProtocol>

@property (assign, nonatomic) BOOL resultStart;
@property (strong, nonatomic) NSError *resultStartError;

@property (assign, nonatomic) BOOL resultReplication;
@property (strong, nonatomic) NSError *resultReplicationError;

@end
