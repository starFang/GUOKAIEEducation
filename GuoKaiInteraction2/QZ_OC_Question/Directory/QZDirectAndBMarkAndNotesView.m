//
//  QZDirectAndBMarkAndNotesView.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-31.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZDirectAndBMarkAndNotesView.h"
#import "DataManager.h"

#define WIDTH 512.0/4

@implementation QZDirectAndBMarkAndNotesView

@synthesize gTableView = _gTableView;
@synthesize dataSource = _dataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)dealloc
{
    [self.gTableView release];
    self.gTableView = nil;
    [self.dataSource release];
    self.dataSource = nil;
    [super dealloc];
}

- (void)initSomeThing
{
    
    [self loadData];
    [self creatTableView];
}

- (void)composition
{
    [self initSomeThing];
    [self note];
    [self directory];
    [self bookMark];
    
}

- (void)loadData
{
    NSArray * array = [DataManager getArrayFromPlist:[NSString stringWithFormat:@"%@/content/contentDict.plist",BOOKNAME]];
    [self.dataSource setArray:array];
}

- (void)creatTableView
{
    self.gTableView = [[UITableView alloc]init];
    self.gTableView.frame = CGRectMake(WIDTH/2, 144, DW/2-WIDTH, DH - 244);
    self.gTableView.delegate = self;
    self.gTableView.dataSource = self;
    [self addSubview:self.gTableView];
}

- (void)directory
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"g_DBN_select@2x.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"g_DBN_selected@2x.png"] forState:UIControlStateSelected];
    button.frame = CGRectMake(WIDTH/2, 50, WIDTH, 44);
    [button addTarget:self action:@selector(endDirectory:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"目录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:62.0/255.0 green:100.0/255.0 blue:36.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:22];
    [self addSubview:button];
}

- (void)bookMark
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"g_DBN_select@2x.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"g_DBN_selected@2x.png"] forState:UIControlStateSelected];
    button.frame = CGRectMake(WIDTH/2 + WIDTH, 50, WIDTH, 44);
    [button setTitle:@"书签" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(endBookMark:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor colorWithRed:62.0/255.0 green:100.0/255.0 blue:36.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:22];
    [self addSubview:button];
}

- (void)note
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"g_DBN_select@2x.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"g_DBN_selected@2x.png"] forState:UIControlStateSelected];
    button.frame = CGRectMake(WIDTH/2 + WIDTH * 2, 50, WIDTH, 44);
    [button setTitle:@"笔记" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(endNote:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor colorWithRed:62.0/255.0 green:100.0/255.0 blue:36.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:22];
    [self addSubview:button];
}

- (void)endDirectory:(id)sender
{

    NSLog(@"目录");
}

- (void)endBookMark:(id)sender
{
    NSLog(@"书签");
}

- (void)endNote:(id)sender
{
    NSLog(@"笔记");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *stringID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stringID];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:stringID] autorelease];
    }
    
    cell.textLabel.text = [[self.dataSource objectAtIndex:indexPath.row] objectAtIndex:0];
    cell.detailTextLabel.text = [[self.dataSource objectAtIndex:indexPath.row] objectAtIndex:1];
    return cell;
}




@end
