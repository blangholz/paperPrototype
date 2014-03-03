//
//  MainViewController.m
//  paperPrototype
//
//  Created by Ben Langholz on 3/1/14.
//  Copyright (c) 2014 Ben Langholz. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileBackground;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet UIView *blackBackground;
@property (nonatomic) float panStartingYPoint;
@property (nonatomic) float alphaZeroToOne;
@property (nonatomic) float containerStartingYPoint;
- (void)onCustomPan:(UIPanGestureRecognizer *)panGestureRecognizer;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.blackBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1136/2)];
    self.blackBackground.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self.view addSubview:self.blackBackground];
    
    self.container = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.container];
    
    UIImage *misoHeadline = [UIImage imageNamed:@"paperHeadline"];
    UIImageView *headline = [[UIImageView alloc] initWithImage:misoHeadline];
    [self.container addSubview:headline];

    [self.container addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(1447, 254);
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onCustomPan:)];
    [self.container addGestureRecognizer:panGestureRecognizer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCustomPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint point = [panGestureRecognizer locationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    float velocityY = velocity.y;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        //figure out where the pangesture started
        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(point));
        
        self.containerStartingYPoint = self.container.frame.origin.y;
        NSLog(@"Frame Began = %f", self.containerStartingYPoint);
        
        self.panStartingYPoint = point.y;
//        NSLog(@"Pan Starting Y Point = %f", self.panStartingYPoint);

    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        //pan current possition - pan starting position = container position
//        NSLog(@"Gesture changed: %@ Velocity changed: %@", NSStringFromCGPoint(point), NSStringFromCGPoint(velocity));
        
        float difference = (point.y-self.panStartingYPoint);
        NSLog(@"difference: %f", difference);
        
        self.container.frame = CGRectMake(0, difference+self.containerStartingYPoint, 320, 1136/2);
//      converting number x from range a-b to number y in range c-d
        float frictionedScroll = (-10) + ((difference)-(-100))/(0-(-100)) * (0-(-10));
        
        
        if (difference+self.containerStartingYPoint < 0) {
            self.container.frame = CGRectMake(0, frictionedScroll, 320, 1136/2);
            NSLog(@"Scrolling up!");
        }
        
//      NSLog(@"0-1 for alpha formula %f",(1 + (self.container.frame.origin.y-0)/(512-0) * (0-1)));
        self.alphaZeroToOne = (1 + (self.container.frame.origin.y-0)/(512-0) * (0-1));
        self.blackBackground.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:self.alphaZeroToOne];
        
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //if velocity positive go up if velvocity negitive go down
        NSLog(@"Gesture ended: %f, Velocity y: %f", point.y, velocityY);
        
        if (velocityY < 0) {
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.container.frame = CGRectMake(0, 0, 320, 1136/2);
                self.blackBackground.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
//                self.profileBackground.frame = CGRectMake(0, 0, 320- (320*.05), (1136/2)-((1136/2)*.05));
            } completion:nil];
        } else if (velocityY > 0) {
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.container.frame = CGRectMake(0, 521, 320, 1136/2);
                self.blackBackground.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            } completion:nil];
        }
        
    }
}

@end
