//
//  MaterialDesignTextField.m
//  JVFloatLabeledTextField
//
//  Created by Fransky on 11/7/16.
//  Copyright © 2016 Jared Verdi. All rights reserved.
//

#import "MaterialDesignTextField.h"
#import "DottedShapeLayer.h"

@implementation MaterialDesignTextField{
   
    CALayer *underLineLayer;
    DottedShapeLayer *dottedLayer;
    UILabel *errorLabel;
    UIImageView *errorImageView;

}


-(void)commonInit{
   
    [super commonInit];
    underLineLayer = [[CALayer alloc] init];
    dottedLayer = [[DottedShapeLayer alloc] init];
    errorLabel = [[UILabel alloc] init];
    errorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icn_warning"]];
    
    [self.layer addSublayer:underLineLayer];
    [self.layer addSublayer:dottedLayer];
    
    self.errorMessageFont = self.floatingLabelFont;
    self.errorColor = [UIColor redColor];
    errorLabel.hidden = YES;
    [self addSubview:errorLabel];
    
    errorImageView.hidden = YES;
    [self addSubview:errorImageView];
    
    self.underlineNormalColor = [UIColor blueColor];
    self.underlineNormalHeight = 1.0f;
    self.underlineHighlightedHeight = 2.0f;

    [self addTarget:self action:@selector(validate) forControlEvents:UIControlEventAllEditingEvents];
    _validationStatus = FloatLabeledTextFieldStatusIndeterminate;
}



-(void)setFloatingLabelActiveTextColor:(UIColor *)floatingLabelActiveTextColor{
    super.floatingLabelActiveTextColor = floatingLabelActiveTextColor;
}


-(UIColor *)floatingLabelActiveTextColor{
    return [super floatingLabelActiveTextColor];
}

-(void)setErrorMessageFont:(UIFont *)errorMessageFont{
    errorLabel.font = errorMessageFont;
}

-(void)setErrorColor:(UIColor *)errorColor{
    _errorColor = errorColor;
    errorLabel.textColor = self.errorColor;

}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    if(self.validationStatus == FloatLabeledTextFieldStatusInvalid){
     
        errorLabel.text = self.errorMessage;
        [errorLabel sizeToFit];
        
        errorLabel.frame = CGRectMake(0, self.frame.size.height+errorLabel.frame.size.height/2, MIN(errorLabel.frame.size.width, self.frame.size.width), errorLabel.frame.size.height);
        
        CGFloat width = errorImageView.image.size.width;
        CGFloat height = errorImageView.image.size.height;
        
        errorImageView.frame = CGRectMake(self.frame.size.width - width, errorLabel.frame.origin.y, width, height);
        errorLabel.hidden = NO;
        
    }
    else{
       errorLabel.text = @"";
       errorLabel.hidden = YES;
    }

}

-(void)layoutSublayersOfLayer:(CALayer *)layer{

    [super layoutSublayersOfLayer: layer];
    
    if(layer == self.layer){
       
        [self computeLineColor];
        
        BOOL invalid = self.validationStatus == FloatLabeledTextFieldStatusInvalid;
        
        CGFloat h = self.isFirstResponder ||  invalid ? _underlineNormalHeight : _underlineNormalHeight;
        CGRect frame = CGRectMake(0,self.frame.size.height - h, self.frame.size.width, h);
        
        if(self.enabled){
           
            underLineLayer.opacity = 1;
            underLineLayer.frame = frame;
            dottedLayer.opacity = 0;
        
        }
        else{
            underLineLayer.opacity = 0;
            dottedLayer.opacity = 1;
            dottedLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            [dottedLayer updateDottedLayerPath:h];
            
        }
    
    }
   
}

-(void)computeLineColor{
    
    struct CGColor *lineColor = _underlineNormalColor.CGColor ? _underlineNormalColor.CGColor : self.tintColor.CGColor;
    
    BOOL invalid = self.validationStatus == FloatLabeledTextFieldStatusInvalid;
    
    if(!invalid){
    
        if(self.isFirstResponder){
           
            if(self.underlineHighlightedColor){
               lineColor = self.underlineHighlightedColor.CGColor;
            }
            else{
                lineColor = self.tintColor.CGColor;
            }
        }
        
    
    } else{
        lineColor = self.errorColor.CGColor;
    }
    
    
    underLineLayer.backgroundColor = lineColor;
    dottedLayer.strokeColor = lineColor;

}




-(void)setAlertString:(NSString *)alertString{
    
    if(alertString.length == 0 || !alertString){alertString = @" ";}
    
    {errorLabel.text = alertString;}
    
    BOOL invalid = self.validationStatus == FloatLabeledTextFieldStatusInvalid;

    errorLabel.hidden = !invalid;
    errorImageView.hidden = !invalid;
    
    self.clipsToBounds = !invalid;
    
    [self setNeedsLayout];
    
}



#pragma mark validation function

#pragma mark - Setters
- (void)setRequired:(BOOL)required
{
    _required = required;
    [self validate];
}

- (void)setValidationStatus:(FloatLabeledTextFieldStatus)status;
{
    _validationStatus = status;
    switch (status) {
        case FloatLabeledTextFieldStatusIndeterminate:
            break;
        case FloatLabeledTextFieldStatusInvalid:
            [self setAlertString:_errorMessage];
            break;
        case FloatLabeledTextFieldStatusValid:
            [self setAlertString:@""];
            break;
    }
    self.rightViewMode = UITextFieldViewModeAlways;
}


- (void)setValidationType:(FloatLabeledTextFieldType)validationType;
{
    _validationType = validationType;
    switch (validationType) {
        case FloatLabeledTextFieldTypeEmail:
            [self applyEmailValidation];
            self.errorMessage = @"Invalid email Address";
            break;
        case FloatLabeledTextFieldTypeURL:
            [self applyURLValidation];
            self.errorMessage = @"Invalid URL Address";
            break;
        case FloatLabeledTextFieldTypePhone:
            [self applyPhoneValidation];
            self.errorMessage = @"Invalid Phone Number";
            break;
        case FloatLabeledTextFieldTypeZIP:
            [self applyZIPValidation];
            self.errorMessage = @"Invalid ZIP Code";
            break;
        default:
            [self clearAllValidationMethods];
            break;
    }
}


- (void)setValidationDelegate:(id<FloatLabeledTextFieldValidationDelegate>)validationDelegate;
{
    [self clearAllValidationMethods];
    _validationDelegate = validationDelegate;
    //    [self validate];
}

- (void)setValidationBlock:(FloatLabeledTextFieldStatus (^)(void))validationBlock;
{
    [self clearAllValidationMethods];
    _validationBlock = validationBlock;
    //    [self validate];
}

- (void)setValidationRegularExpression:(NSRegularExpression *)validationRegularExpression;
{
    [self clearAllValidationMethods];
    _validationRegularExpression = validationRegularExpression;
    //    [self validate];
}

#pragma mark - Setting built-in validation types
- (void)applyEmailValidation;
{
    [self clearAllValidationMethods];
    __weak MaterialDesignTextField *weakSelf = self;
    self.validationBlock = ^{
        if (weakSelf.text.length == 0 && !weakSelf.isRequired) {
            return FloatLabeledTextFieldStatusIndeterminate;
        }
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:NULL];
        NSArray *matches = [detector matchesInString:weakSelf.text options:0 range:NSMakeRange(0, weakSelf.text.length)];
        for (NSTextCheckingResult *match in matches) {
            if (match.resultType == NSTextCheckingTypeLink &&
                [match.URL.absoluteString rangeOfString:@"mailto:"].location != NSNotFound) {
                return FloatLabeledTextFieldStatusValid;
            }
        }
        return FloatLabeledTextFieldStatusInvalid;
    };
    [self validate];
}

- (void)applyURLValidation;
{
    [self clearAllValidationMethods];
    __weak MaterialDesignTextField *weakSelf = self;
    self.validationBlock = ^{
        if (weakSelf.text.length == 0 && !weakSelf.isRequired) {
            return FloatLabeledTextFieldStatusIndeterminate;
        }
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:NULL];
        NSArray *matches = [detector matchesInString:weakSelf.text options:0 range:NSMakeRange(0, weakSelf.text.length)];
        return (NSInteger)matches.count;
    };
    [self validate];
}

- (void)applyPhoneValidation;
{
    [self clearAllValidationMethods];
    __weak MaterialDesignTextField *weakSelf = self;
    self.validationBlock = ^{
        if (weakSelf.text.length == 0 && !weakSelf.isRequired) {
            return FloatLabeledTextFieldStatusIndeterminate;
        }
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:NULL];
        NSArray *matches = [detector matchesInString:weakSelf.text options:0 range:NSMakeRange(0, weakSelf.text.length)];
        return (NSInteger)matches.count;
    };
    [self validate];
}

- (void)applyZIPValidation;
{
    [self clearAllValidationMethods];
    __weak MaterialDesignTextField *weakSelf = self;
    self.validationBlock = ^{
        if (weakSelf.text.length == 0 && !weakSelf.isRequired) {
            return FloatLabeledTextFieldStatusIndeterminate;
        }
        NSString *justNumbers = [[weakSelf.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        if (justNumbers.length == 5 || justNumbers.length == 9) {
            return FloatLabeledTextFieldStatusValid;
        }
        return FloatLabeledTextFieldStatusInvalid;
    };
    [self validate];
}

- (void)clearAllValidationMethods;
{
    _validationRegularExpression = nil;
    _validationDelegate = nil;
    _validationBlock = nil;
    _validationType = FloatLabeledTextFieldTypeNone;
}

#pragma mark - Validation
- (void)validate;
{
    if (self.validationDelegate) {
        self.validationStatus = [self.validationDelegate textFieldStatus:self];
    } else if (self.validationBlock) {
        self.validationStatus = self.validationBlock();
    } else if (self.validationRegularExpression) {
        [self validateWithRegularExpression];
    }
}

- (void)validateWithRegularExpression
{
    if (self.text.length == 0 && !self.isRequired) {
        self.validationStatus = FloatLabeledTextFieldStatusIndeterminate;
    } else if ([self.validationRegularExpression numberOfMatchesInString:self.text options:0 range:NSMakeRange(0, self.text.length)]) {
        self.validationStatus = FloatLabeledTextFieldStatusValid;
    } else {
        self.validationStatus = FloatLabeledTextFieldStatusInvalid;
    }
}






@end
