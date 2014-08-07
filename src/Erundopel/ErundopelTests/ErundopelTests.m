//
//  ErundopelTests.m
//  ErundopelTests
//
//  Created by Admin on 28/07/14.
//  Copyright (c) 2014 Noveo Summer Internship. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Parse/Parse.h>

@interface ErundopelTests : XCTestCase

@end

@implementation ErundopelTests

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

- (void)testExample
{
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testParseConnection {
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
}

@end
