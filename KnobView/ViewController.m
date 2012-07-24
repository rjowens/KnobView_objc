//
//  ViewController.m
//  KnobView
//
//  Created by Richard Owens on 7/9/12.
//  Copyright (c) 2012 Richard J Owens. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize knobView1;
@synthesize knobView2;
@synthesize knobView3;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:216.0/255.0 alpha:1.0];        

    self.knobView1 = [[KnobView alloc] initWithFrame:CGRectMake(20, 40, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.width - 40)];    
    [self.view addSubview:self.knobView1];
    
    self.knobView2 = [[KnobView alloc] initWithFrame:CGRectMake(20, 330, [UIScreen mainScreen].bounds.size.width - 200, [UIScreen mainScreen].bounds.size.width - 200)];
    [self.view addSubview:self.knobView2];
    
    self.knobView3 = [[KnobView alloc] initWithFrame:CGRectMake(180, 330, [UIScreen mainScreen].bounds.size.width - 200, [UIScreen mainScreen].bounds.size.width - 200)];
    [self.view addSubview:self.knobView3];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
