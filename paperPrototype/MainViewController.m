//
//  MainViewController.m
//  paperPrototype
//
//  Created by Ben Langholz on 3/1/14.
//  Copyright (c) 2014 Ben Langholz. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
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
    
    self.containerStartingYPoint = self.container.center.y;
    NSLog(@"Starting Y Point from Center = %f", self.containerStartingYPoint);
    
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
        
        self.panStartingYPoint = point.y;
        NSLog(@"Pan Starting Y Point = %f", self.panStartingYPoint);

    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        //pan current possition - pan starting position = container position
//        NSLog(@"Gesture changed: %@ Velocity changed: %@", NSStringFromCGPoint(point), NSStringFromCGPoint(velocity));
        
        float difference = (point.y-self.panStartingYPoint);
        NSLog(@"difference: %f", difference);
        
        self.container.frame = CGRectMake(0, difference, 320, 1136/2);
        
        if (difference < 0) {
            self.container.frame = CGRectMake(0, 0, 320, 1136/2);
        }
        
        NSLog(@"0-1 for alpha %f",((self.container.frame.origin.y/521)-1)*-1);
        
        self.alphaZeroToOne = ((self.container.frame.origin.y/521)-1)*-1;
        
        self.blackBackground.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:self.alphaZeroToOne];
        
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //if velocity positive go up if velvocity negitive go down
        NSLog(@"Gesture ended: %@, Velocity y: %f", NSStringFromCGPoint(point), velocityY);
        
        if (velocityY < 0) {
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.container.frame = CGRectMake(0, 0, 320, 1136/2);
            } completion:nil];
        } else if (velocityY > 0) {
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.container.frame = CGRectMake(0, 521, 320, 1136/2);
            } completion:nil];
        }
        
    }
}

@end
