//
//  QZNotesCell.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-11-2.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZNotesCell.h"

@implementation QZNotesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_QZNotesTime release];
    [_QZPNum release];
    [_QZLineWords release];
    [_QZNotes release];
    [super dealloc];
}
@end
