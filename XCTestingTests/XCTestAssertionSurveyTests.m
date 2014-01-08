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

// OCUnit => STAssertTrue
- (void)testTrue
{
    XCTAssertTrue(YES, @"What happend to: True dat?");
}

// OCUnit => STAssertFalse
- (void)testFalse
{
    XCTAssertFalse(NO, @"Maybe was \"falls\"?");
}

// OCUnit => STAssertTrue; XCTestAssert is essentially XCTAssertTrue
- (void)testGeneralAssert
{
    XCTAssert(@"something" != nil, @"We got something for nothing?");
}

// OCUnit => STAssertNil
- (void)testNil
{
    XCTAssertNil(nil, @"Yep. Wait, what?");
}

// OCUnit => STAssertNotNil
- (void)testNotNil
{
    XCTAssertNotNil(@"someting", @"WAT?");
}

// OCUnit => STAssertEqual
- (void)testEqual
{
    int ten = 10;
    int ninePlusOne = 10;
    XCTAssertEqual(ten, ninePlusOne, @"should have been equal.");
    // NOTE: The 'equal' assertions do a decent job of reporting the mismatched values on failure,
    //       so I am not including the compared values in the failure format string.
}

// OCUnit => STAssertNotEqual
- (void)testNotEqual
{
    int ten = 10;
    int nine = 9;
    XCTAssertNotEqual(ten, nine, @"should NOT have been equal.");
}

// OCUnit => STAssertEqualObjects
- (void)testObjectsEqual
{
    NSString *first = @"identity";
    NSString *second = first;
    XCTAssertEqualObjects(first, second, @"should have been equal.");
}

// OCUnit => STAssertNotEqualObjects
- (void)testObjectsNotEqual
{
    NSString *first = @"identity";
    NSString *second = @"id";
    XCTAssertNotEqualObjects(first, second, @"should NOT have been equal.");
}

// OCUnit => STAssertEqualWithAccuracy
- (void)testEqualWithAccuracy
{
    float first = 10.0f;
    float second = 10.0001f;
    XCTAssertEqualWithAccuracy(first, second, 0.0002f, @"close, but no cigar");
}

// OCUnit => STAssertNotEqualWithAccuracy
- (void)testNotEqualWithAccuracy
{
    float first = 10.0f;
    float second = 10.0003f;
    XCTAssertNotEqualWithAccuracy(first, second, 0.0002f, @"objects in mirror...?");
}

// OCUnit => STAssertThrows
- (void)testThrows
{
    XCTAssertThrows([self throwNSException], @"throw a fit");
}

// OCUnit => STAssertThrowsSpecific
- (void)testSpecificThrows
{
    XCTAssertThrowsSpecific([self throwNSException], NSException, @"throw a fit");
}

// OCUnit => STAssertThrowsSpecificNamed
- (void)testSpecificNameThrows
{
    XCTAssertThrowsSpecificNamed([self throwNSException], NSException, @"Hell", @"wrong exception specifics");
}

// OCUnit => STAssertNoThrow
- (void)testThrowsNotForThee
{
    XCTAssertNoThrow([self behave], @"it threw a fit");
}

// OCUnit => STAssertNoThrowSpecific
- (void)testDoesNotThrowSpecific
{
    XCTAssertNoThrowSpecific([self throwNSException], TestException, @"it was the wrong kind - specifically");
}

// OCUnit => STAssertNoThrowSpecificNamed
- (void)testDoesNotThrowSpecificNamed
{
    XCTAssertNoThrowSpecificNamed([self throwNSException], NSException, @"Heaven", @"wrong exception specifics");
}

#pragma mark - Demonstration methods that require editing to see the result

// OCUnit => STFail
- (void)testFail
{
    if (NO) {
        // Change NO above to YES to demonstrate this.
        XCTFail(@"If you need something to fail, this is the way.");
    }
}

- (void)testFailMessageFormatting
{
    NSString *value = @"indubitably";
    // Have to make it fail to see the message. Swap the two lines below.
    // XCTAssert(value == nil, @"'%@' was nil!?", value);
    XCTAssert(value != nil, @"'%@' was nil!?", value);
}

/*
    No direct XCTest equivalent for STAssertTrueNoThrow and STAssertFalseNoThrow
 */

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
