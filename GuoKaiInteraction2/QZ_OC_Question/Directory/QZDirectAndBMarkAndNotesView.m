//
//  QZDirectAndBMarkAndNotesView.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-31.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZDirectAndBMarkAndNotesView.h"
#import "DataManager.h"
#import "Database.h"

#define WIDTH 512.0/4

@implementation QZDirectAndBMarkAndNotesView
@synthesize delegate;
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
    [self setBackImage];
    [self loadDirectoryData];
    [self creatTableView];
}
- (void)setBackImage
{
    UIImage *image = [UIImage imageNamed:@"g_DBN_BackImage.png"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(ZERO, ZERO, DW/2, DH-20)];
    imageView.backgroundColor = [UIColor greenColor];
    [imageView setImage:image];
    [self addSubview:imageView];
    [imageView release];
}

- (void)composition
{
    [self initSomeThing];
    [self note];
    [self directory];
    [self bookMark];
    
}

- (void)loadDirectoryData
{
    NSArray * array = [DataManager getArrayFromPlist:[NSString stringWithFormat:@"%@/content/contentDict.plist",BOOKNAME]];
    [self.dataSource setArray:array];
     [self.gTableView reloadData];
}

- (void)loadBookMarkData
{
  NSArray *arrayBook = [DataManager getArrayFromPlist:[NSString stringWithFormat:@"%@/content/BookMark.plist",BOOKNAME]];
    [self.dataSource setArray:arrayBook];
    [self.gTableView reloadData];
}

- (void)loadNoteData
{
    NSLog(@"%@",[[Database sharedDatabase]selectAllData]);
}

- (void)creatTableView
{
    self.gTableView = [[UITableView alloc]init];
    self.gTableView.frame = CGRectMake(WIDTH/2, 144, DW/2-WIDTH, DH - 244);
    self.gTableView.delegate = self;
    self.gTableView.dataSource = self;
    self.gTableView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.gTableView];
}

- (void)directory
{
    DirectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [DirectBtn setBackgroundImage:[UIImage imageNamed:@"g_DBN_Direct_seelct@2x.png"] forState:UIControlStateNormal];
    [DirectBtn setBackgroundImage:[UIImage imageNamed:@"g_DBN_Direct_seelcted@2x.png"] forState:UIControlStateSelected];
    DirectBtn.frame = CGRectMake(WIDTH/2, 50, WIDTH, 44);
    [DirectBtn addTarget:self action:@selector(endDirectory:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:DirectBtn];
}

- (void)bookMark
{
    BookMarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [BookMarkBtn setBackgroundImage:[UIImage imageNamed:@"g_DBN_BMark_seelct@2x.png"] forState:UIControlStateNormal];
    [BookMarkBtn setBackgroundImage:[UIImage imageNamed:@"g_DBN_BMark_seelcted@2x.png"] forState:UIControlStateSelected];
    BookMarkBtn.frame = CGRectMake(WIDTH/2 + WIDTH, 50, WIDTH, 44);
    [BookMarkBtn addTarget:self action:@selector(endBookMark:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:BookMarkBtn];
}

- (void)note
{
    NotesMarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [NotesMarkBtn setBackgroundImage:[UIImage imageNamed:@"g_DBN_Note_seelct@2x.png"] forState:UIControlStateNormal];
    [NotesMarkBtn setBackgroundImage:[UIImage imageNamed:@"g_DBN_Note_seelcted@2x.png"] forState:UIControlStateSelected];
    NotesMarkBtn.frame = CGRectMake(WIDTH/2 + WIDTH * 2, 50, WIDTH, 44);
    [NotesMarkBtn addTarget:self action:@selector(endNote:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:NotesMarkBtn];
}

- (void)endDirectory:(UIButton *)button
{
    button.selected = !button.selected;
    [self loadDirectoryData];
    if (button.selected)
    {
        BookMarkBtn.selected = NO;
        NotesMarkBtn.selected = NO;
    }
}

- (void)endBookMark:(UIButton *)button
{
    button.selected = !button.selected;
    if ( button.selected)
    {
        [self loadBookMarkData];
        DirectBtn.selected = NO;
        NotesMarkBtn.selected = NO;
    }
}

- (void)endNote:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected)
    {
        [self loadNoteData];
        DirectBtn.selected = NO;
        BookMarkBtn.selected = NO;
    }

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


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    [cell.backgroundView addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"g_DBN_BackImage_cell.png"]]];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
NSInteger pageNum = [[[self.dataSource objectAtIndex:indexPath.row] objectAtIndex:1] integerValue];
    [self.delegate openTheSelectedPage:pageNum];
}


@end
