//
//  IAWLogFormatter.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 04/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>



@interface IAWLogFormatter : NSObject <DDLogFormatter>

+ (instancetype)logFormatter;

@end
