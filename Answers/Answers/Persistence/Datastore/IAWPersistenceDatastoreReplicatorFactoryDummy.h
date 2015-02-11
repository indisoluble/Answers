//
//  IAWPersistenceDatastoreReplicatorFactoryDummy.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 10/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWPersistenceDatastoreReplicatorFactoryProtocol.h"



@interface IAWPersistenceDatastoreReplicatorFactoryDummy : NSObject <IAWPersistenceDatastoreReplicatorFactoryProtocol>

+ (instancetype)factory;

@end
