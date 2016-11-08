//
//  MaterialDesignTextField.h
//  JVFloatLabeledTextField
//
//  Created by Fransky on 11/7/16.
//  Copyright © 2016 Jared Verdi. All rights reserved.
//

#import "JVFloatLabeledTextField.h"

@class MaterialDesignTextField;

//validation inspired by https://github.com/jmenter/JAMValidatingTextField
/** TextField status modes. */
typedef NS_ENUM(NSInteger, FloatLabeledTextFieldStatus) {
    FloatLabeledTextFieldStatusIndeterminate = -1,
    FloatLabeledTextFieldStatusInvalid,
    FloatLabeledTextFieldStatusValid
};

/** TextField types. */
typedef NS_ENUM(NSUInteger, FloatLabeledTextFieldType) {
    FloatLabeledTextFieldTypeNone,
    FloatLabeledTextFieldTypeEmail,
    FloatLabeledTextFieldTypeURL,
    FloatLabeledTextFieldTypePhone,
    FloatLabeledTextFieldTypeZIP
};


/** The delegate is used for validation if it is assigned. */
@protocol FloatLabeledTextFieldValidationDelegate <NSObject>
@optional
-(FloatLabeledTextFieldStatus)textFieldStatus:(MaterialDesignTextField *)textField;
@end


@interface MaterialDesignTextField : JVFloatLabeledTextField


@property (nonatomic, strong) IBInspectable UIColor * underlineNormalColor;
@property (nonatomic, strong) IBInspectable UIColor * underlineHighlightedColor;
@property (nonatomic) IBInspectable CGFloat underlineNormalHeight;
@property (nonatomic) IBInspectable CGFloat underlineHighlightedHeight;

@property (nonatomic, strong)IBInspectable UIFont *errorMessageFont;
@property (nonatomic, strong)IBInspectable UIColor *errorColor;


@property (nonatomic) IBInspectable NSString *alertString;


/** Use this to get the validation status of your text field. */
@property (nonatomic, readonly) FloatLabeledTextFieldStatus validationStatus;

/** Use this property to easily set a validation type for your text field. */
@property (nonatomic) FloatLabeledTextFieldType validationType;

/** Normally, an empty text field is considered "indeterminate." Setting isRequired to YES will cause the textfield to be considered invalid even when it is empty. */
@property (nonatomic, getter = isRequired) BOOL required;

@property (nonatomic, copy) FloatLabeledTextFieldStatus (^validationBlock)(void);
@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, strong) NSIndexPath *idxPath;

/** Sets the validation mechanism to be an NSRegularExpression. One or more matches will indicate a valid condition.
 @param validationRegularExpression the regular expression to use.
 */
@property (nonatomic) NSRegularExpression *validationRegularExpression;

/** Sets the validation mechanism to be a MTFloatLabeledTextFieldValidationDelegate. */
@property (nonatomic, weak) id <FloatLabeledTextFieldValidationDelegate> validationDelegate;

-(void)validate;



@end
