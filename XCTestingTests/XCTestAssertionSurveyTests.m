//
//  XCTestingTests.m
//  XCTestingTests
//
//  Created by Kevin Munc on 2014/01/07.
//  Copyright (c) 2014 Method Up. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TestException : NSException

@end

@implementation TestException

@end

@interface XCTestAssertionSurveyTests : XCTestCase

@end

@implementation XCTestAssertionSurveyTests

#pragma mark - xUnit lifecycle methods

- (void)setUp
{
    [super setUp]; // Always call super.
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown]; // Always call super. Note that is is called *after* your own tear down code; opposite of setUp.
}

#pragma mark - Simple demos of the assertions in XCTest

- (void)testGeneralAssert
{
    XCTAssert(@"something" != nil, @"We got something for nothing?");
}

- (void)testTrue
{
    XCTAssertTrue(YES, @"What happend to: True dat?");
}

- (void)testFalse
{
    XCTAssertFalse(NO, @"Maybe was \"falls\"?");
}

- (void)testNil
{
    XCTAssertNil(nil, @"Yep. Wait, what?");
}

- (void)testNotNil
{
    XCTAssertNotNil(@"someting", @"WAT?");
}

- (void)testEqual
{
    int ten = 10;
    int ninePlusOne = 10;
    XCTAssertEqual(ten, ninePlusOne, @"should have been equal.");
    // NOTE: The 'equal' assertions do a decent job of reporting the mismatched values on failure,
    //       so I am not including the compared values in the failure format string.
}

- (void)testNotEqual
{
    int ten = 10;
    int nine = 9;
    XCTAssertNotEqual(ten, nine, @"should NOT have been equal.");
}

- (void)testObjectsEqual
{
    NSString *first = @"identity";
    NSString *second = first;
    XCTAssertEqualObjects(first, second, @"should have been equal.");
}

- (void)testObjectsNotEqual
{
    NSString *first = @"identity";
    NSString *second = @"id";
    XCTAssertNotEqualObjects(first, second, @"should NOT have been equal.");
}

- (void)testEqualWithAccuracy
{
    float first = 10.0f;
    float second = 10.0001f;
    XCTAssertEqualWithAccuracy(first, second, 0.0002f, @"close, but no cigar");
}

- (void)testNotEqualWithAccuracy
{
    float first = 10.0f;
    float second = 10.0003f;
    XCTAssertNotEqualWithAccuracy(first, second, 0.0002f, @"objects in mirror...?");
}

- (void)testThrows
{
    XCTAssertThrows([self throwSimpleException], @"throw a fit");
}

- (void)testSpecificThrows
{
    XCTAssertThrowsSpecific([self throwNSException], NSException, @"throw a fit");
}

- (void)testSpecificNameThrows
{
    XCTAssertThrowsSpecificNamed([self throwNSException], NSException, @"Hell", @"wrong exception specifics");
}

- (void)testThrowsNotForThee
{
    XCTAssertNoThrow([self behave], @"it threw a fit");
}

- (void)testDoesNotThrowSpecific
{
    XCTAssertNoThrowSpecific([self throwNSException], TestException, @"it was the wrong kind - specifically");
}

- (void)testDoesNotThrowSpecificNamed
{
    XCTAssertNoThrowSpecificNamed([self throwNSException], NSException, @"Heaven", @"wrong exception specifics");
}

#pragma mark - Demonstration methods that require editing to see the result

- (void)testFailMessageFormatting
{
    NSString *value = @"indubitably";
    // Have to make it fail to see the message. Swap the two lines below.
    // XCTAssert(value == nil, @"'%@' was nil!?", value);
    XCTAssert(value != nil, @"'%@' was nil!?", value);
}

- (void)testFail
{
    if (NO) {
        // Change NO above to YES to demonstrate this.
        XCTFail(@"If you need something to fail, this is the way.");
    }
}

#pragma mark - Helper Methods

- (void)throwSimpleException
{
    @throw @"The compiler made me do it.";
}

- (void)throwNSException
{
    [NSException raise:@"Hell" format:@"on ObjC wheels"];
}

- (void)behave
{
    NSLog(@"Don't look at me to throw a wrench in the works.");
}

@end
