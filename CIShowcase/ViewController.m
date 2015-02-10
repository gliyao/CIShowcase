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
@property (strong, nonatomic) CIImage *backgroundImage;
@property (strong, nonatomic) NSArray *filterCategories;
@property (strong, nonatomic) NSString *filterName;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _filterCategories = @[
                          @"CICategoryBlur",
                          @"CICategoryColorAdjustment", // 顏色調整
                          @"CICategoryColorEffect",
                          @"CICategoryCompositeOperation", // 兩張照片inputBackgroundImage 跟inputImage
                          @"CICategoryDistortionEffect", // 失真效果
//                          @"CICategoryGenerator",
                          @"CICategoryGeometryAdjustment",
//                          @"CICategoryGradient",
                          @"CICategoryHalftoneEffect",//半色調
//                          @"CICategoryReduction",
                          @"CICategorySharpen", //銳利化
//                          @"CICategoryStylize",
//                          @"CICategoryTileEffect",
//                          @"CICategoryTransition", // 轉場效果
                          ];
    
    _originImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"icecream"]];
    _backgroundImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"park"]];
    
    
    NSString *filterName = [self categoreisOfIndex:0][0];
    [self filterImageWithFilerName:filterName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)filterImageWithFilerName:(NSString *)filterName {
    
    self.filterName = filterName;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        CIFilter *filter = [CIFilter filterWithName:filterName];
        NSLog(@"inputKeys = %@, outputKeys = %@", filter.inputKeys, filter.outputKeys);
        
        [self filter:filter setValue:_originImage forKey:kCIInputImageKey];
        [self filter:filter setValue:_backgroundImage forKey:kCIInputBackgroundImageKey];
        
        
        CIImage *outputImage = [filter outputImage];
        CIContext *context = [CIContext contextWithOptions:nil];
        UIImage *newImage = [UIImage imageWithCGImage:[context createCGImage:outputImage fromRect:outputImage.extent]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = newImage;
        });
    });
}

- (void)filter:(CIFilter *)filter setValue:(id)value forKey:(NSString *)key {
    
    if ([filter.inputKeys containsObject:key]) {
        [filter setValue:value forKey:key];
    }
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
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    
    NSString *filterName = [self categoreisOfIndex:categoryIndex][filterIndex];
    [self filterImageWithFilerName:filterName];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *textLabel = (UILabel *)view;
    if (!textLabel){
        textLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        textLabel.font = [UIFont systemFontOfSize:14];
    }
    // Fill the label text here
    
    if(component == 0){
        
        NSString *categoryName = self.filterCategories[row];
        textLabel.text = [categoryName substringFromIndex:10];
        return textLabel;
    }
    
    NSInteger selectedCategoryIndex = [pickerView selectedRowInComponent:0];
    NSString *subCategoryName = [self categoreisOfIndex:selectedCategoryIndex][row];
    textLabel.text =  [subCategoryName substringFromIndex:2];
    return textLabel;
}

@end


