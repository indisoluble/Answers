//
//  IAWModelQuestionTests.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 01/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "IAWModelQuestion.h"



#define IAWMODELQUESTIONTESTS_QUESTIONTEXT  @"This is a question"



@interface IAWModelQuestionTests : XCTestCase

@end



@implementation IAWModelQuestionTests

- (void)setUp
{
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    [super tearDown];
}

- (void)testSimpleInitFails
{
    XCTAssertNil([[IAWModelQuestion alloc] init], @"'init' should fail");
}

- (void)testInitWithQuestionTextSetToNilFails
{
    XCTAssertNil([[IAWModelQuestion alloc] initWithQuestionText:nil], @"The text is mandatory");
}

- (void)testInitWithEmptyQuestionTextFails
{
    XCTAssertNil([[IAWModelQuestion alloc] initWithQuestionText:@""], @"An empty string is not a valid question");
}

- (void)testQuestionTextIsSetToCorrectValueAfterInit
{
    NSString *txt = [NSString stringWithFormat:@"  %@  ", IAWMODELQUESTIONTESTS_QUESTIONTEXT];
    IAWModelQuestion *oneQuestion = [[IAWModelQuestion alloc] initWithQuestionText:txt];
    
    XCTAssertEqualObjects(oneQuestion.questionText, IAWMODELQUESTIONTESTS_QUESTIONTEXT,
                          @"After a correct initialization, the question text should be set");
}

@end
