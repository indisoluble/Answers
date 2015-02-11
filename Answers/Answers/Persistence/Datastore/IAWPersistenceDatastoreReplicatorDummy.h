//
//  IAWPersistenceDatastoreReplicatorDummy.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 10/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWPersistenceDatastoreReplicatorProtocol.h"



#define IAWPERSISTENCEDATASTOREREPLICATORDUMMY_ERRORCODE    1



extern NSString * const kIAWPersistenceDatastoreReplicatorDummyErrorDomain;



@interface IAWPersistenceDatastoreReplicatorDummy : NSObject <IAWPersistenceDatastoreReplicatorProtocol>

+ (instancetype)replicator;

@end
