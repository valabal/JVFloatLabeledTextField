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
    
    self.errorMessageFont = [UIFont systemFontOfSize:10];
    self.errorColor = [UIColor redColor];
    errorLabel.hidden = YES;
    [self addSubview:errorLabel];
    
    errorImageView.hidden = YES;
    [self addSubview:errorImageView];
    
    self.underlineNormalColor = [UIColor clearColor];
    self.underlineNormalHeight = 1.0f;
    self.underlineHighlightedHeight = 2.0f;

}



-(void)setFloatingLabelActiveTextColor:(UIColor *)floatingLabelActiveTextColor{

    super.floatingLabelActiveTextColor = floatingLabelActiveTextColor;
}


-(UIColor *)floatingLabelActiveTextColor{
    return [super floatingLabelActiveTextColor];
}



-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    if(!self.valid){
     
        errorLabel.text = self.errorMessage;
        [errorLabel sizeToFit];
        
        errorLabel.frame = CGRectMake(0, self.frame.size.height+errorLabel.frame.size.height/2, MIN(errorLabel.frame.size.width, self.frame.size.width), errorLabel.frame.size.height);
        
        CGFloat width = errorImageView.image.size.width;
        CGFloat height = errorImageView.image.size.height;
        
        errorImageView.frame = CGRectMake(self.frame.size.width - width, errorLabel.frame.origin.y, width, height);
        
    }
    else{
       errorLabel.text = @"";
    }

}

-(void)layoutSublayersOfLayer:(CALayer *)layer{

    [super layoutSublayersOfLayer: layer];
    
    if(layer == self.layer){
       
        [self computeLineColor];
        
        CGFloat h = self.isFirstResponder || !self.valid ? _underlineNormalHeight : _underlineNormalHeight;
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
    
    struct CGColor *lineColor = _underlineNormalColor.CGColor;
    
    if(self.valid){
    
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


@end
