//
//  IAWLogFormatter.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 04/02/2015.
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

#import "IAWLogFormatter.h"



NSString * const kIAWLogFormatterLogLevelError = @"E";
NSString * const kIAWLogFormatterLogLevelWarning = @"W";
NSString * const kIAWLogFormatterLogLevelInfo = @"I";
NSString * const kIAWLogFormatterLogLevelDebug = @"D";
NSString * const kIAWLogFormatterLogLevelVerbose = @"V";



@interface IAWLogFormatter ()

@property (strong, nonatomic, readonly) NSDateFormatter *threadUnsafeDateFormatter;

@property (assign, nonatomic) NSInteger loggerCount;

@end



@implementation IAWLogFormatter

#pragma mark - Init object
- (id)init
{
    self = [super init];
    if(self)
    {
        _threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
        _threadUnsafeDateFormatter.formatterBehavior = NSDateFormatterBehavior10_4;
        _threadUnsafeDateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss:SSS";
        
        _loggerCount = 0;
    }
    
    return self;
}


#pragma mark - DDLogFormatter methods
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString *logLevel = [IAWLogFormatter logLevelForFlag:logMessage.flag];
    NSString *dateAndTime = [self.threadUnsafeDateFormatter stringFromDate:(logMessage.timestamp)];
    
    NSString *msg = [NSString stringWithFormat:@"%@ %@ (%lu) <%@> # %@",
                     dateAndTime,
                     logMessage.function,
                     (unsigned long)logMessage.line,
                     logLevel,
                     logMessage.message];
    
    return msg;
}

- (void)didAddToLogger:(id<DDLogger>)logger
{
    self.loggerCount++;
    
    NSAssert(self.loggerCount <= 1, @"This logger isn't thread-safe");
}

- (void)willRemoveFromLogger:(id<DDLogger>)logger
{
    self.loggerCount--;
}


#pragma mark - Public class methods
+ (instancetype)logFormatter
{
    return [[[self class] alloc] init];
}


#pragma mark - Private class methods
+ (NSString *)logLevelForFlag:(DDLogFlag)flag
{
    NSString *logLevel = nil;
    
    switch (flag)
    {
        case DDLogFlagError:
        {
            logLevel = kIAWLogFormatterLogLevelError;
            
            break;
        }
        case DDLogFlagWarning:
        {
            logLevel = kIAWLogFormatterLogLevelWarning;
            
            break;
        }
        case DDLogFlagInfo:
        {
            logLevel = kIAWLogFormatterLogLevelInfo;
            
            break;
        }
        case DDLogFlagDebug:
        {
            logLevel = kIAWLogFormatterLogLevelDebug;
            
            break;
        }
        case DDLogFlagVerbose:
        default:
        {
            logLevel = kIAWLogFormatterLogLevelVerbose;
            
            break;
        }
    }
    
    return logLevel;
}

@end
