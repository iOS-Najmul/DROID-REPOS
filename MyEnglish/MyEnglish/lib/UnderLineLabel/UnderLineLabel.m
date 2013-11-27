//
//  UnderLineLabel.m
//  
//
//  Created by Guntis Treulands on 8/01/12.
//

#import "UnderLineLabel.h"

@implementation UnderLineLabel

@synthesize shouldUnderline;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
    
    }
    
    return self;
}

- (void) drawRect:(CGRect) rect
{
    if (shouldUnderline)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        const CGFloat* colors = CGColorGetComponents(self.textColor.CGColor);
        
        if (self.textColor == [UIColor blackColor]) {
            CGContextSetRGBStrokeColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
        }else{
            CGContextSetRGBStrokeColor(ctx, colors[0], colors[1], colors[2], 1.0);
        }
        
        CGContextSetLineWidth(ctx, 1.0f);
        
        CGContextMoveToPoint(ctx, 0, self.bounds.size.height - 1);
        CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height - 1);
        
        CGContextStrokePath(ctx);
    }
    
    [super drawRect:rect];
}

@end
