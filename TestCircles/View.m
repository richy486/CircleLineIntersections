//
//  View.m
//  TestCircles
//
//  Created by Richard Adem on 13/03/13.
//  Copyright (c) 2013 Richard Adem. All rights reserved.
//

#import "View.h"

@implementation View

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rotation = 0.0;
        [self setBackgroundColor:[UIColor blackColor]];
        
        self.position = CGPointMake(420.0, 100);
        self.position2 = CGPointMake(400.0, 400);
        self.chordPercent = 0.5;
        self.radiusPercent = 0.5;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat colourYellow[4] = {1.0f, 1.0f, 0.0f, 1.0f};
    CGFloat colourYellow2[4] = {0.75f, 1.0f, 0.0f, 1.0f};
    CGFloat colourOrange[4] = {1.0f, 0.5f, 0.0f, 1.0f};
    CGFloat colourGreen[4] = {0.0f, 1.0f, 0.0f, 1.0f};
    CGFloat colourRed[4] = {1.0f, 0.0f, 0.0f, 1.0f};
    CGFloat colourWhite[4] = {1.0f, 1.0f, 1.0f, 1.0f};
    
    double radius = self.radiusPercent * 300.0;
    CGFloat centreX = 400.0;
    CGFloat centreY = 400.0;
    CGFloat chord = self.chordPercent * (2*radius);
    CGFloat angle = -self.rotation;
    
    CGPoint pointA = self.position;
    CGPoint pointB = self.position2;
    
    {
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColor(c, colourWhite);
        CGContextAddEllipseInRect(c, CGRectMake(centreX - radius, centreY - radius, radius*2, radius*2));
        CGContextStrokePath(c);
    }
    {
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColor(c, colourWhite);
        CGContextAddEllipseInRect(c, CGRectMake(centreX-5, centreY-5, 10.0, 10.0));
        CGContextStrokePath(c);
    }
    
    {
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColor(c, colourRed);
        CGContextMoveToPoint(c, centreX, centreY);
        CGContextAddLineToPoint(c
                                , centreX + radius * cos(angle)
                                , centreY - radius * sin(angle));
        CGContextStrokePath(c);
    }
    {
        CGFloat colourRedFade[4] = {1.0f, 0.0f, 0.0f, 0.4f};
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColor(c, colourRedFade);
        CGContextMoveToPoint(c, centreX, centreY);
        CGContextAddLineToPoint(c
                                , centreX - radius * cos(angle)
                                , centreY + radius * sin(angle));
        CGContextStrokePath(c);
    }
    
    {
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColor(c, colourYellow);
        CGContextMoveToPoint(c, pointA.x, pointA.y);
        CGContextAddLineToPoint(c, pointB.x, pointB.y);
        CGContextStrokePath(c);
    }
    
    CGFloat min = -M_PI;
    CGFloat max = M_PI;
    angle = [self wrap:angle max:max min:min];

    // theta = 2 arcsin(c/[2r]),
    CGFloat theta = 2 * asin(chord / (2 * radius));
    CGFloat startPoint = -angle - (theta/2) - M_PI_2;
    CGFloat endPoint = startPoint + theta;
    
    
    {
        
        
        BOOL clockwise = YES;
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColor(c, colourOrange);
        CGContextAddArc(c,
                        centreX,
                        centreY,
                        radius,
                        startPoint,
                        endPoint,
                        clockwise ? 0 : 1); // UIView flips the Y-coordinate
        CGContextStrokePath(c);
        
        
        
        
        {
            CGContextRef c = UIGraphicsGetCurrentContext();
            CGContextSetStrokeColor(c, colourGreen);
            CGContextMoveToPoint(c
                                 , centreX + radius * cos(startPoint)
                                 , centreY + radius * sin(startPoint));
            CGContextAddLineToPoint(c
                                    , centreX + radius * cos(endPoint)
                                    , centreY + radius * sin(endPoint));
            CGContextStrokePath(c);
        }
    }
    
    float intersectionA = 0.0;
    float intersectionB = 0.0;
    BOOL intersection = [self circleLineIntersectionPointA:pointA
                                                    pointB:pointB
                                               circlePoint:CGPointMake(centreX, centreY)
                                              circleRadius:radius
                                             intersectionA:&intersectionA intersectionB:&intersectionB];
    
     
    CGPoint p1 = CGPointMake(((pointB.x - pointA.x) * intersectionA) + pointA.x
                            , ((pointB.y - pointA.y) * intersectionA) + pointA.y);
    
    CGPoint p2 = CGPointMake(((pointB.x - pointA.x) * intersectionB) + pointA.x
                             , ((pointB.y - pointA.y) * intersectionB) + pointA.y);
    
    CGFloat theta1 = atan2(p1.y - centreY, p1.x - centreX);
    CGFloat theta2 = atan2(p2.y - centreY, p2.x - centreX);

    BOOL inside1 = NO;
    BOOL inside2 = NO;
    CGFloat startPointNorm = [self wrap:startPoint max:max min:min];
    CGFloat endPointNorm = [self wrap:endPoint max:max min:min];    
    if (startPointNorm < endPointNorm)
    {
        inside1 = theta1 >= startPointNorm && theta1 <= endPointNorm;
        inside2 = theta2 >= startPointNorm && theta2 <= endPointNorm;
    }
    else
    {
        if (startPointNorm >= 0.0 && endPointNorm <= 0.0)
        {
            if ((theta1 >= startPointNorm && theta1 <= M_PI && theta1 >= 0)
                || (theta1 <= endPointNorm && theta1 >= -M_PI && theta1 <= 0)
                )
            {
                inside1 = YES;
            }
            
            if ((theta2 >= startPointNorm && theta2 <= M_PI && theta2 >= 0)
                || (theta2 <= endPointNorm && theta2 >= -M_PI && theta2 <= 0)
                )
            {
                inside2 = YES;
            }
        }
        else
        {
            if (theta1 <= startPointNorm && theta1 >= endPointNorm)
            {
                inside1 = YES;
            }
            if (theta2 <= startPointNorm && theta2 >= endPointNorm)
            {
                inside2 = YES;
            }
        }

    }
//    NSLog(@"intersection: %d, startPointNorm %.05f, theta1: %.05f, endPointNorm %.05f, ", intersection, startPointNorm, theta1, endPointNorm);

    {
        CGContextRef c = UIGraphicsGetCurrentContext();
        if (inside1)
        {
            CGContextSetStrokeColor(c, colourRed);
        }
        else
        {
            CGContextSetStrokeColor(c, colourYellow);
        }
        CGContextAddEllipseInRect(c, CGRectMake(p1.x-5, p1.y-5, 10.0, 10.0));
        CGContextStrokePath(c);
    }
    {
        CGContextRef c = UIGraphicsGetCurrentContext();
        if (inside2)
        {
            CGContextSetStrokeColor(c, colourRed);
        }
        else
        {
            CGContextSetStrokeColor(c, colourYellow);
        }
        CGContextAddEllipseInRect(c, CGRectMake(p2.x-5, p2.y-5, 10.0, 10.0));
        CGContextStrokePath(c);
    }

}

- (float) dot:(CGPoint)p1 andPoint:(CGPoint)p2
{
	return (p1.x * p2.x) + (p1.y * p2.y);
}

// http://www.dreamincode.net/forums/topic/277514-normalize-angle-and-radians/
- (double) wrap:(double) value max:(double) max min:(double) min
{
    value -= min;
    max -= min;
    if (max == 0)
        return min;
    
    value = fmod(value, max); // value % max;
    value += min;
    while (value < min)
    {
        value += max;
    }
    
    return value;
}


// http://stackoverflow.com/a/1084899/667834
- (BOOL) circleLineIntersectionPointA:(CGPoint) pointA pointB:(CGPoint) pointB
                          circlePoint:(CGPoint) circlePoint circleRadius:(CGFloat) radius
                        intersectionA:(float*)intersectionA intersectionB:(float*)intersectionB
{
    CGPoint d = CGPointMake(pointB.x - pointA.x, pointB.y - pointA.y);
    CGPoint f = CGPointMake(pointA.x - circlePoint.x, pointA.y - circlePoint.y);
    CGFloat r = radius;
    
    float a = [self dot:d andPoint:d];  //d.Dot( d ) ;
    float b = 2* [self dot:f andPoint:d];   //f.Dot( d ) ;
    float c = [self dot:f andPoint:f] - r*r ;
    
    float discriminant = b*b-4*a*c;
    if( discriminant < 0 ) // &lt;
    {
        // no intersection
    }
    else
    {
        // ray didn't totally miss sphere,
        // so there is a solution to
        // the equation.
        
        discriminant = sqrt( discriminant );
        
        // either solution may be on or off the ray so need to test both
        // t1 is always the smaller value, because BOTH discriminant and
        // a are nonnegative.
        float t1 = (-b - discriminant)/(2*a);
        float t2 = (-b + discriminant)/(2*a);
        
        *intersectionA = t1;
        *intersectionB = t2;
        
        // 3x HIT cases:
        //          -o->             --|-->  |            |  --|->
        // Impale(t1 hit,t2 hit), Poke(t1 hit,t2>1), ExitWound(t1<0, t2 hit),
        
        // 3x MISS cases:
        //       ->  o                     o ->              | -> |
        // FallShort (t1>1,t2>1), Past (t1<0,t2<0), CompletelyInside(t1<0, t2>1)
        
        if( t1 >= 0 && t1 <= 1 )
        {
            // t1 is an intersection, and if it hits,
            // it's closer than t2 would be
            // Impale, Poke
            return YES ;
        }
        
        // here t1 didn't intersect so we are either started
        // inside the sphere or completely past it
        if( t2 >= 0 && t2 <= 1 )
        {
            // ExitWound
            return YES ;
        }
        
        // no intn: FallShort, Past, CompletelyInside
        return NO ;
    }
    
    return NO;
}

@end
