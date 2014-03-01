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
    
    
    UIView *container = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:container];
    
    UIImage *misoHeadline = [UIImage imageNamed:@"paperHeadline"];
    UIImageView *headline = [[UIImageView alloc] initWithImage:misoHeadline];
    [container addSubview:headline];

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
    [container addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(1447, 254);
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onCustomPan:)];
    [container addGestureRecognizer:panGestureRecognizer];
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
        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(point));
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Gesture changed: %@", NSStringFromCGPoint(point));
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended: %@", NSStringFromCGPoint(point));
    }
}

@end
