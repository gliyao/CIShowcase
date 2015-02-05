//
//  CIShowcaseTests.m
//  CIShowcaseTests
//
//  Created by Liyao on 2015/2/5.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface CIShowcaseTests : XCTestCase

@property (strong, nonatomic) NSArray *filterCategories;

@end

@implementation CIShowcaseTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _filterCategories = @[
                          @"CICategoryBlur",
                          @"CICategoryColorAdjustment",
                          @"CICategoryColorEffect",
                          @"CICategoryCompositeOperation",
                          @"CICategoryDistortionEffect",
                          @"CICategoryGenerator",
                          @"CICategoryGeometryAdjustment",
                          @"CICategoryGradient",
                          @"CICategoryHalftoneEffect",
                          @"CICategoryReduction",
                          @"CICategorySharpen",
                          @"CICategoryStylize",
                          @"CICategoryTileEffect",
                          @"CICategoryTransition",
                          ];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testShowAllFilterCategories {
    
    [_filterCategories enumerateObjectsUsingBlock:^(NSString *category, NSUInteger idx, BOOL *stop) {
        NSArray *subCategories = [CIFilter filterNamesInCategory:category];
        NSLog(@"%@", subCategories);
    }];
}

- (void)testA {
    
    NSString *filterCategory = _filterCategories[4];
    NSString *filterName = [CIFilter filterNamesInCategory:filterCategory][1];
    CIFilter *filter = [CIFilter filterWithName:filterName];
    
    NSLog(@"%@", filter.inputKeys);
}


@end
