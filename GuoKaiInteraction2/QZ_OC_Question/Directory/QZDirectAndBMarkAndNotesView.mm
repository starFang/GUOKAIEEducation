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

#import "QZLineDataModel.h"
#import "QZBookMarkDataModel.h"
#import "QZDirectDataModel.h"

#import "QZDirectCell.h"
#import "QZBookMarkCell.h"
#import "QZNotesCell.h"

#import "QZRootViewController.h"

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
    NSMutableArray *arrayDirect = [[NSMutableArray alloc]init];
    for (int i = 0; i < [array count]; i++)
    {
        QZDirectDataModel *directDM = [[QZDirectDataModel alloc]init];
        [directDM setDPageTitle:[[array objectAtIndex:i] objectAtIndex:0]];
        [directDM setDPageNumber:[[array objectAtIndex:i] objectAtIndex:1]];
        [arrayDirect addObject:directDM];
        [directDM release];
    }
    [self.dataSource setArray:arrayDirect];
    [arrayDirect release];
    [self.gTableView reloadData];
}

- (void)loadBookMarkData
{
//    NSMutableArray *array = [[NSMutableArray alloc]init];
//    NSMutableArray *arrayBMark = [[NSMutableArray alloc]init];
//    [arrayBMark setArray:[DataManager shareDataManager].bookMarkDataArray];
//    for (int i = 0; i < [arrayBMark count]; i++)
//    {
//        QZBookMarkDataModel *bmDataModel  = [[QZBookMarkDataModel alloc]init];
//        if ([[arrayBMark objectAtIndex:i] count] >= 2)
//        {
//        [bmDataModel setBmPageNumber:[[[arrayBMark objectAtIndex:i] objectAtIndex:1] intValue]];
//        }
//        
//        if ([[arrayBMark objectAtIndex:i] count] >= 2)
//        {
//        [bmDataModel setBmPageTitle:[[arrayBMark objectAtIndex:i] objectAtIndex:0]];
//        }
//        
//        if ([[arrayBMark objectAtIndex:i] count] >= 3)
//        {
//          [bmDataModel setBmDate:[[arrayBMark objectAtIndex:i] objectAtIndex:2]];  
//        }
//        
//        [array addObject:bmDataModel];
//        [bmDataModel release];
//    }
//    [self.dataSource setArray:array];
//    [array release];
//    [self.gTableView reloadData];
//    
//    return;
    [self.dataSource setArray:[DataManager shareDataManager].bookMarkDataArray];
    [self.gTableView reloadData];
    
}

- (void)loadNoteData
{
    NSArray *arrayNote = [[Database sharedDatabase]selectAllData];
    [self.dataSource setArray:arrayNote];
    [self.gTableView reloadData];
}

- (void)creatTableView
{
    self.gTableView = [[UITableView alloc]init];
    self.gTableView.frame = CGRectMake(WIDTH/2, 144, DW/2-WIDTH, DH - 244);
    self.gTableView.delegate = self;
    self.gTableView.dataSource = self;
    self.gTableView.backgroundColor = [UIColor clearColor];
    self.gTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self addSubview:self.gTableView];
}

- (void)directory
{
    DirectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [DirectBtn setImage:[UIImage imageNamed:@"g_DBN_Direct_seelct@2x.png"] forState:UIControlStateNormal];
    [DirectBtn setImage:[UIImage imageNamed:@"g_DBN_Direct_seelcted@2x.png"] forState:UIControlStateSelected];
    [DirectBtn setImage:[UIImage imageNamed:@"g_DBN_Direct_seelcted@2x.png"] forState:UIControlStateHighlighted];
    DirectBtn.selected = YES;
    DirectBtn.frame = CGRectMake(WIDTH/2, 50, WIDTH, 44);
    [DirectBtn addTarget:self action:@selector(endDirectory:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:DirectBtn];
}

- (void)bookMark
{
    BookMarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [BookMarkBtn setImage:[UIImage imageNamed:@"g_DBN_BMark_seelct@2x.png"] forState:UIControlStateNormal];
    [BookMarkBtn setImage:[UIImage imageNamed:@"g_DBN_BMark_seelcted@2x.png"] forState:UIControlStateSelected];
    [BookMarkBtn setImage:[UIImage imageNamed:@"g_DBN_BMark_seelcted@2x.png"] forState:UIControlStateHighlighted];
    BookMarkBtn.selected = NO;
    BookMarkBtn.frame = CGRectMake(WIDTH/2 + WIDTH, 50, WIDTH, 44);
    [BookMarkBtn addTarget:self action:@selector(endBookMark:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:BookMarkBtn];
}

- (void)note
{
    NotesMarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [NotesMarkBtn setImage:[UIImage imageNamed:@"g_DBN_Note_seelct@2x.png"] forState:UIControlStateNormal];
    [NotesMarkBtn setImage:[UIImage imageNamed:@"g_DBN_Note_seelcted@2x.png"] forState:UIControlStateSelected];
    [NotesMarkBtn setImage:[UIImage imageNamed:@"g_DBN_Note_seelcted@2x.png"] forState:UIControlStateHighlighted];    
    NotesMarkBtn.selected = NO;
    NotesMarkBtn.frame = CGRectMake(WIDTH/2 + WIDTH * 2, 50, WIDTH, 44);
    [NotesMarkBtn addTarget:self action:@selector(endNote:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:NotesMarkBtn];
}

- (void)endDirectory:(UIButton *)button
{
    button.selected = YES;
    
    if (button.selected)
    {
        BookMarkBtn.selected = NO;
        NotesMarkBtn.selected = NO;
        [self loadDirectoryData];
    }
}

- (void)endBookMark:(UIButton *)button
{
    button.selected = YES;
    if ( button.selected)
    {
        DirectBtn.selected = NO;
        NotesMarkBtn.selected = NO;
        [self loadBookMarkData];
    }
}

- (void)endNote:(UIButton *)button
{
    button.selected = YES;
    if (button.selected)
    {
        DirectBtn.selected = NO;
        BookMarkBtn.selected = NO;
        [self loadNoteData];
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (DirectBtn.selected)
    {
        return 40.0f;
    }else if (BookMarkBtn.selected){
        return 75.0f;
    }else if (NotesMarkBtn.selected) {
        return 90.0f;
        
//        QZLineDataModel *lineData = [self.dataSource objectAtIndex:indexPath.row];
//       lineData.lineDate;
//        [NSString stringWithFormat:@"%d",[lineData.linePageNumber integerValue]+1];
//        lineData.lineWords;
//        
//        if (lineData.lineCritique)
//        {
//            lineData.lineCritique;
//        }else{
//            @"没有批注";
//        }
//        
//    UIFont *font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:33];
//    CGSize size = [[NSString stringWithUTF8String:pageRichTextImage->stTitle.strText.c_str()] sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, 44) lineBreakMode:NSLineBreakByCharWrapping];
    
        
    }
    return 0.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (DirectBtn.selected)
    {
        static NSString *DirectID = @"DirectID";
        QZDirectCell *cell = [tableView dequeueReusableCellWithIdentifier:DirectID];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"QZDirectCell" owner:self options:nil]lastObject];
        }
        QZDirectDataModel *directDM = [self.dataSource objectAtIndex:indexPath.row];
        cell.QZDirectTitle.text = directDM.dPageTitle;
        cell.QZPageNumber.text = [NSString stringWithFormat:@"%d",[directDM.dPageNumber integerValue]+1];
        return cell;
    } else if (BookMarkBtn.selected){
        
        static NSString *BookMarkID = @"BookMarkID";
        QZBookMarkCell *cell = [tableView dequeueReusableCellWithIdentifier:BookMarkID];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"QZBookMarkCell" owner:self options:nil]lastObject];
        }
        QZBookMarkDataModel *bmDM = [self.dataSource objectAtIndex:indexPath.row];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd(EEE) k:mm:ss"];
        cell.QZMarkTime.text = [formatter stringFromDate:bmDM.bmDate];
        cell.QZMarkPNum.text = [NSString stringWithFormat:@"%d",bmDM.bmPageNumber +1];
        cell.QZMarkTitle.text = bmDM.bmPageTitle;
        return cell;
    } else if (NotesMarkBtn.selected){
        static NSString *NotesID = @"NotesID";
        QZNotesCell *cell = [tableView dequeueReusableCellWithIdentifier:NotesID];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"QZNotesCell" owner:self options:nil]lastObject];
        }
        QZLineDataModel *lineData = [self.dataSource objectAtIndex:indexPath.row];
        cell.QZNotesTime.text = lineData.lineDate;
        cell.QZPNum.text = [NSString stringWithFormat:@"%d",[lineData.linePageNumber integerValue]+1];
        cell.QZLineWords.text = lineData.lineWords;
        
        if (lineData.lineCritique)
        {
            cell.QZNotes.text = lineData.lineCritique;
        }else{
            cell.QZNotes.text = @"没有批注";
        }
        return cell;
    }
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    cell.textLabel.text = @"你的数据为空！";
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    [cell.backgroundView addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"g_DBN_BackImage_cell.png"]]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (DirectBtn.selected)
    {
        QZDirectDataModel *direct = [self.dataSource objectAtIndex:indexPath.row];
        [self.delegate openTheSelectedPage:[direct.dPageNumber integerValue]];
    }else if (NotesMarkBtn.selected){
        
        QZLineDataModel *lineData = [self.dataSource objectAtIndex:indexPath.row];
        [self.delegate openTheSelectedPage:[lineData.linePageNumber integerValue]];
    }else if (BookMarkBtn.selected){
        
        QZBookMarkDataModel *bMarkData = [self.dataSource objectAtIndex:indexPath.row];
        [self.delegate openTheSelectedPage:bMarkData.bmPageNumber ];
    }
}

@end
