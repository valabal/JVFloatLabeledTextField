//
//  MaterialDesignTextField.h
//  JVFloatLabeledTextField
//
//  Created by Fransky on 11/7/16.
//  Copyright © 2016 Jared Verdi. All rights reserved.
//

#import <JVFloatLabeledText/JVFloatLabeledText.h>


@interface MaterialDesignTextField : JVFloatLabeledTextField


@property (nonatomic, strong) IBInspectable UIColor * underlineNormalColor;
@property (nonatomic, strong) IBInspectable UIColor * underlineHighlightedColor;
@property (nonatomic) IBInspectable CGFloat underlineNormalHeight;
@property (nonatomic) IBInspectable CGFloat underlineHighlightedHeight;

@property (nonatomic, strong)IBInspectable UIFont *errorMessageFont;
@property (nonatomic, strong)IBInspectable UIColor *errorColor;


@property (nonatomic,strong) NSString *errorMessage;
@property (nonatomic) BOOL valid;


@end
