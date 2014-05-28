//
//  VPRubberCell.m
//  VPRubberTable
//
//  Created by Vitalii Popruzhenko on 5/27/14.
//  Copyright (c) 2014 Vitaliy Popruzhenko. All rights reserved.
//

#import "VPRubberCell.h"
@interface VPRubberCell ()
@end

@implementation VPRubberCell

-(void)setNewHeight:(CGFloat)h{
    if (h > MAX_H){
        heightNew = MAX_H;
    } else if (h < -MAX_H){
        heightNew = -MAX_H;
    } else {
        heightNew = h;
    }
    [self.layer setMask:[self mask]];
}

- (UIBezierPath *)pathWithHeight:(CGFloat)height{
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(0, 0+MAX_H)];
    [bezierPath addCurveToPoint: CGPointMake(self.frame.size.width, 0+MAX_H) controlPoint1: CGPointMake(self.frame.size.width/2, (0+MAX_H)+height) controlPoint2: CGPointMake(self.frame.size.width, 0+MAX_H)];
    [bezierPath addLineToPoint: CGPointMake(self.frame.size.width, self.frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(0, self.frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(0, 0+MAX_H)];
    return bezierPath;
}

- (CAShapeLayer *)mask{
    UIBezierPath *myClippingPath = [self pathWithHeight:heightNew];
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = myClippingPath.CGPath;
    return mask;
}

@end
