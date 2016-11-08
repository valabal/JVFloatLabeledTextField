//
//  JVFloatLabeledTextFieldXIBViewController.m
//  JVFloatLabeledTextField
//
//  Created by Jared Verdi on 4/2/16.
//  Copyright © 2016 Jared Verdi. All rights reserved.
//

#import "JVFloatLabeledTextFieldXIBViewController.h"
#import "MaterialDesignTextField.h"

@interface JVFloatLabeledTextFieldXIBViewController ()

@property(strong,nonatomic) IBOutlet MaterialDesignTextField *titleField;

@end

@implementation JVFloatLabeledTextFieldXIBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleField.validationBlock = ^{
        if (_titleField.text.length == 0) {
            _titleField.errorMessage = @"This field is required";
            return FloatLabeledTextFieldStatusInvalid;
        }
        
        return FloatLabeledTextFieldStatusValid;
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
