//
//  IAWPersistenceDatastoreNotificationCenter.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 02/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>



extern NSString * const kIAWPersistenceDatastoreNotificationCenterDidChangeNotification;



@interface IAWPersistenceDatastoreNotificationCenter : NSObject

- (id)initWithNotificationCenter:(NSNotificationCenter *)notificationCenterOrNil;

- (void)addDidChangeNotificationObserver:(id)observer selector:(SEL)aSelector sender:(id)sender;
- (void)removeDidChangeNotificationObserver:(id)observer sender:(id)sender;
- (void)postDidChangeNotificationWithSender:(id)sender;

+ (instancetype)notificationCenter;

@end
