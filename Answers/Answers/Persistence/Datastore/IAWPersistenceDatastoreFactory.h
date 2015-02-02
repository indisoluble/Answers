//
//  IAWPersistenceDatastoreFactory.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 01/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWPersistenceDatastoreProtocol.h"



@interface IAWPersistenceDatastoreFactory : NSObject

+ (id<IAWPersistenceDatastoreProtocol>)datastore;

@end
