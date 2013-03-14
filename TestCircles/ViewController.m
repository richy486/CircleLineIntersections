//
//  ViewController.m
//  TestCircles
//
//  Created by Richard Adem on 13/03/13.
//  Copyright (c) 2013 Richard Adem. All rights reserved.
//

#import "ViewController.h"
#import "View.h"

@interface ViewController ()
{
    float _prevRotation;
    CGPoint _beginPan;
    CGPoint _beginPan2;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setView:[[View alloc] init]];
    
    _prevRotation = 0.0;
    _beginPan = CGPointZero;
    _beginPan2 = CGPointZero;
    
    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotateGestureAction:)];
    [rotateGesture setDelegate:self];
    [self.view addGestureRecognizer:rotateGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
    [panGesture setDelegate:self];
    [panGesture setMaximumNumberOfTouches:1];
    [panGesture setMinimumNumberOfTouches:1];
    [self.view addGestureRecognizer:panGesture];
    
    UIPanGestureRecognizer *panGesture2 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction2:)];
    [panGesture2 setDelegate:self];
    [panGesture2 setMaximumNumberOfTouches:2];
    [panGesture2 setMinimumNumberOfTouches:2];
    [self.view addGestureRecognizer:panGesture2];
    
    UISlider *sliderChord = [[UISlider alloc] initWithFrame:CGRectMake(10, 900, 400, 50)];
    [sliderChord setBackgroundColor:[UIColor orangeColor]];
    [sliderChord addTarget:self action:@selector(valueChanged_sliderChord:) forControlEvents:UIControlEventValueChanged];
    [sliderChord setValue:[(View*)self.view chordPercent]];
    [self.view addSubview:sliderChord];
    
    UISlider *sliderRadius = [[UISlider alloc] initWithFrame:CGRectMake(10, 950, 400, 50)];
    [sliderRadius setBackgroundColor:[UIColor whiteColor]];
    [sliderRadius addTarget:self action:@selector(valueChanged_sliderRadius:) forControlEvents:UIControlEventValueChanged];
    [sliderRadius setValue:[(View*)self.view radiusPercent]];
    [self.view addSubview:sliderRadius];
}

#pragma mark - events

- (void) valueChanged_sliderChord:(UISlider*) slider
{
    [(View*)self.view setChordPercent:slider.value];
    [self.view setNeedsDisplay];
}

- (void) valueChanged_sliderRadius:(UISlider*) slider
{
    [(View*)self.view setRadiusPercent:slider.value];
    [self.view setNeedsDisplay];
}

#pragma mark - gestures

- (void)rotateGestureAction:(UIRotationGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan
        || (_prevRotation < 0.0 && gestureRecognizer.rotation > 0.0)
        || (_prevRotation > 0.0 && gestureRecognizer.rotation < 0.0))
    {
        _prevRotation = 0.0;
    }
    float thisRotate = gestureRecognizer.rotation - _prevRotation;
    _prevRotation = gestureRecognizer.rotation;
    
    [(View*)self.view setRotation:[(View*)self.view rotation] + thisRotate];
    
//    NSLog(@"rotation: %.02f, prevRotation: %.02f |||| rotation: %.02f", gestureRecognizer.rotation, _prevRotation, [(View*)self.view rotation]);
    
    [self.view setNeedsDisplay];
}

- (void) panGestureAction:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint newCenter = [gestureRecognizer translationInView:self.view];
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        _beginPan.x = [(View*)self.view position].x;
        _beginPan.y = [(View*)self.view position].y;
        
        
        
    }
    newCenter = CGPointMake(_beginPan.x + newCenter.x, _beginPan.y + newCenter.y);
    
    
    [(View*)self.view setPosition:newCenter];
    
    [self.view setNeedsDisplay];
}
- (void) panGestureAction2:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint newCenter = [gestureRecognizer translationInView:self.view];
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        _beginPan2.x = [(View*)self.view position2].x;
        _beginPan2.y = [(View*)self.view position2].y;
        
        
        
    }
    newCenter = CGPointMake(_beginPan2.x + newCenter.x, _beginPan2.y + newCenter.y);
    
    
    [(View*)self.view setPosition2:newCenter];
    
    [self.view setNeedsDisplay];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
