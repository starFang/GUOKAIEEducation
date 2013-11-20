//
//  QZBookShelfViewController.m
//  QZBookShelf
//
//  Created by qanzone on 13-11-2.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZBookShelfViewController.h"
#import "QZBookOfPageViewController.h"

@interface QZBookShelfViewController ()

@end

@implementation QZBookShelfViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)BackImage
{
    UIImage *backImage = [UIImage imageNamed:@"102x4.png"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1204, 748)];
    [imageView setImage:backImage];
    [self.view addSubview:imageView];
    [imageView release];
}

- (void)headTitleView
{
    UIImage *headImage = [UIImage imageNamed:@"g_headTitle@2x.png"];
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 50)];
    [headImageView setImage:headImage];
    [self.view addSubview:headImageView];
    [headImageView release];
}

- (void)bookShelfView
{
    UIScrollView *scBookShelf = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 1024, 749)];
    scBookShelf.tag = 200;
    scBookShelf.contentSize = CGSizeMake(1024, 748);
    
    UIImage *image = [UIImage imageNamed:@"g_bookShelf.png"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    imageView.userInteractionEnabled = YES;
    [imageView setImage:image];
    [scBookShelf addSubview:imageView];
    [imageView release];
    
    UIImage *image1 = [UIImage imageNamed:@"g_bookShelf.png"];
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748)];
    [imageView1 setImage:image1];
    [scBookShelf addSubview:imageView1];
    [imageView1 release];
    [self.view addSubview:scBookShelf];
    [scBookShelf release];

}

- (void)book
{
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 14; i++)
    {
        [array addObject:[NSString stringWithFormat:@"%d.png",i+1]];
    }
    
    UIScrollView *scBookShelf = (UIScrollView *)[self.view viewWithTag:200];
    for (int i = 0; i < [array count]; i++)
    {
        UIImage *image = [UIImage imageNamed:[array objectAtIndex:i]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(60 + 160*(i%6), 72+175*(i/6), 100, 140);
        button.tag = 300 + i;
        [button addTarget:self action:@selector(pressBook:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:image forState:UIControlStateNormal];
        [scBookShelf addSubview:button];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self BackImage];
    [self bookShelfView];
    [self headTitleView];
    [self book];
}


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
//    [super viewWillAppear:animated];
}
- (void)pressBook:(UIButton *)button
{
    QZBookOfPageViewController *bookOfPage = [[QZBookOfPageViewController alloc]init];
//    bookOfPage.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    bookOfPage.modalPresentationStyle = UIModalPresentationCurrentContext;
//    [self presentViewController:bookOfPage animated:YES completion:nil];
    
    [self.navigationController pushViewController:bookOfPage animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
