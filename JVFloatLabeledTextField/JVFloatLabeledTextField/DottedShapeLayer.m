//
//  DottedShapeLayer.m
//  JVFloatLabeledTextField
//
//  Created by Fransky on 11/7/16.
//  Copyright © 2016 Jared Verdi. All rights reserved.
//

#import "DottedShapeLayer.h"

@implementation DottedShapeLayer


-(instancetype)init{
   
    self = [super init];
    if(self){
        [self commonInit];
    }
    
    return self;
    
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
   
    self = [super initWithCoder:aDecoder];
    if(self){
        [self commonInit];
    }
    
    return self;

}


-(instancetype)initWithLayer:(id)layer{
    
    self= [super initWithLayer:layer];
    if(self){
        [self commonInit];
    }
    
    return self;

}

-(void)commonInit{
    self.backgroundColor = [UIColor clearColor].CGColor;
    self.strokeStart = 0.0f;
    self.lineWidth = 1.0f;
    self.lineJoin = kCALineJoinMiter;
    self.lineDashPattern = @[@2,@2];
}


-(void)updateDottedLayerPath:(CGFloat )h{
   
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:(CGPointMake(0, self.frame.size.height-h))];
    [path addLineToPoint:(CGPointMake(self.frame.size.width, self.frame.size.height))];
    
    self.path = path.CGPath;
}


@end
