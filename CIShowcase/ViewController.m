//
//  ViewController.m
//  CIShowcase
//
//  Created by Liyao on 2015/2/5.
//
//

#import "ViewController.h"

@import CoreImage;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong, nonatomic) CIImage *originImage;
@property (strong, nonatomic) NSArray *filterCategories;
@property (strong, nonatomic) NSString *filterName;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _filterCategories = @[
                          @"CICategoryBlur",
                          @"CICategoryColorAdjustment",
                          @"CICategoryColorEffect",
                          @"CICategoryCompositeOperation",
                          @"CICategoryDistortionEffect",
//                          @"CICategoryGenerator",
                          @"CICategoryGeometryAdjustment",
//                          @"CICategoryGradient",
                          @"CICategoryHalftoneEffect",
                          @"CICategoryReduction",
                          @"CICategorySharpen",
                          @"CICategoryStylize",
                          @"CICategoryTileEffect",
                          @"CICategoryTransition",
                          ];
    
    _originImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"icecream"]];
    
    NSString *filterName = [self categoreisOfIndex:0][0];
    [self filterImageWithFilerName:filterName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
    
}

- (void)filterImageWithFilerName:(NSString *)filterName {
    
    self.filterName = filterName;
    
    CIFilter *filter = [CIFilter filterWithName:filterName];
    [filter setValue:_originImage forKey:kCIInputImageKey];
    
    NSLog(@"inputKeys = %@, outputKeys = %@", filter.inputKeys, filter.outputKeys);
    
    UIImage *newImage = [UIImage imageWithCGImage:[[CIContext contextWithOptions:nil] createCGImage:[filter outputImage] fromRect:[filter outputImage].extent]];
    self.imageView.image = newImage;
}

- (NSArray *)categoreisOfIndex:(NSInteger)index {
    
    return [CIFilter filterNamesInCategory:self.filterCategories[index]];
}

@end


@interface ViewController(PickerView)<UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation ViewController(PickerView)


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if(component == 0){
        return self.filterCategories.count;
    }
    
    NSInteger selectedCategoryIndex = [pickerView selectedRowInComponent:0];
    return [self categoreisOfIndex:selectedCategoryIndex].count;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if(component == 0){
        
        NSString *categoryName = self.filterCategories[row];
        return [categoryName substringFromIndex:10];
    }
    
    NSInteger selectedCategoryIndex = [pickerView selectedRowInComponent:0];
    NSString *subCategoryName = [self categoreisOfIndex:selectedCategoryIndex][row];
    return [subCategoryName substringFromIndex:2];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSInteger categoryIndex = (component == 0)? row: [pickerView selectedRowInComponent:0];
    NSInteger filterIndex = (component == 1)? row: 0;
    if(component == 0){
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:NO];
    }
    
    NSString *filterName = [self categoreisOfIndex:categoryIndex][filterIndex];
    [self filterImageWithFilerName:filterName];
}

@end


