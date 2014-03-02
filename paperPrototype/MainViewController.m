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
@property (nonatomic) float panStartingYPoint;
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
    
    
    self.container = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.container];
    
    UIImage *misoHeadline = [UIImage imageNamed:@"paperHeadline"];
    UIImageView *headline = [[UIImageView alloc] initWithImage:misoHeadline];
    [self.container addSubview:headline];

//    UIScrollView *scrollingStories =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 254)];
//    [self.view addSubview:scrollingStories];
//
//    UIImage *paperStoies = [UIImage imageNamed:@"paperStories"];
//    UIImageView *stories = [[UIImageView alloc] initWithImage:paperStoies];
//    [scrollingStories setFrame:CGRectMake(0, 0, 1447, 254)];
//    [scrollingStories addSubview:stories];
//    
//    scrollingStories.clipsToBounds = NO;
//    
//    scrollingStories.contentSize=CGSizeMake(1447,254);
    [self.container addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(1447, 254);
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onCustomPan:)];
    [self.container addGestureRecognizer:panGestureRecognizer];
    
    NSLog(@"Starting container = %@", self.container);
    
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
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        //figure out where the pangesture started
        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(point));
        
        self.panStartingYPoint = point.y;
        NSLog(@"Pan Starting Y Point = %f", self.panStartingYPoint);

    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        //pan current possition - pan starting position = container position
        NSLog(@"Gesture changed: %@ Velocity: %@", NSStringFromCGPoint(point), NSStringFromCGPoint(velocity));
        
        CGRect movingPosition = self.container.frame;
        movingPosition.origin = CGPointMake(movingPosition.origin.x, movingPosition.origin.y+((point.y-self.panStartingYPoint)/10));
        self.container.frame = movingPosition;
        
        NSLog(@"movingPosition = %@", NSStringFromCGRect(movingPosition));
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //if velocity positive go up if velvocity negitive go down
        NSLog(@"Gesture ended: %@", NSStringFromCGPoint(point));
    }
}

@end
