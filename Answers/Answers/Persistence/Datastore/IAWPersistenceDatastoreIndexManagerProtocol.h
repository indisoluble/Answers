//
//  IAWPersistenceDatastoreIndexManagerProtocol.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 15/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol IAWPersistenceDatastoreIndexManagerProtocol <NSObject>

- (id<NSFastEnumeration>)queryWithDictionary:(NSDictionary *)dictionary
                                       error:(NSError **)error;

@end
