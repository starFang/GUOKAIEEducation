
#import "MusicToolView.h"
#import "MarkupParser.h"

@implementation MusicToolView
@synthesize musicTitle;

- (void)dealloc
{
    [self.musicTitle release];
    self.musicTitle = nil;
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
     }
    return self;
}

- (void)initIncomingData:(PageVoice *)pageVoice
{
    pVoice = pageVoice;
}

- (void)composition
{
    if (pVoice->stTitle.isRichText == YES)
    {
        [self isYesRichText];
    }else{
        [self initTitle:self.frame];
    }
    
    CGRect frame;
    if (SFSH >= MUSICTOOLVIEW_SIZE_WEIGHT && SFSW >= MUSICTOOLVIEW_SIZE_WIDTH)
    {
        frame = self.frame;
    }else if (SFSH >= MUSICTOOLVIEW_SIZE_WEIGHT && SFSW <= MUSICTOOLVIEW_SIZE_WIDTH)
    {
        frame = CGRectMake(SFOX, SFOY, MUSICTOOLVIEW_SIZE_WIDTH, SFSH);
    }else if (SFSH <= MUSICTOOLVIEW_SIZE_WEIGHT && SFSW >= MUSICTOOLVIEW_SIZE_WIDTH)
    {
        frame = CGRectMake(SFOX, SFOY, SFSW, MUSICTOOLVIEW_SIZE_WEIGHT);
    }else if (SFSH <= MUSICTOOLVIEW_SIZE_WEIGHT && SFSW <= MUSICTOOLVIEW_SIZE_WIDTH)
    {
        frame = CGRectMake(SFOX, SFOY, MUSICTOOLVIEW_SIZE_WIDTH, MUSICTOOLVIEW_SIZE_WEIGHT);
    }
    
    [self initButton:frame];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(myTimer:) userInfo:nil repeats:YES];
    [self sliderVolume:frame];
    [self mp3Player:[NSString stringWithUTF8String:pVoice->strVoicePath.c_str()]];
}

- (void)isYesRichText
{
    NSMutableString *strBegin = [[NSMutableString alloc]initWithString:@""];
    NSMutableString *string = [[NSMutableString alloc]initWithString:@""];
    NSMutableString * strFont = [NSMutableString string];
    CGFloat fontsize;
    MarkupParser *p = [[[MarkupParser alloc]init]autorelease];
    for (int i = 0; i < pVoice->stTitle.vTextItemList.size(); i++)
    {
        switch (pVoice->stTitle.vTextItemList[i].pieceType)
        {
            case PAGE_RICH_TEXT_PIECE_PARAGRAPH_BEGIN:
            {
                if (![strBegin length]) {
                    
                }else{
                    [strBegin appendString:@"\n"];
                    [string appendString:@"\n"];
                }
                UIFont *font = [UIFont fontWithName:[NSString stringWithUTF8String:pVoice->stTitle.vTextItemList[i].fontFamily.c_str()] size:pVoice->stTitle.vTextItemList[i].fontSize];
                CGSize sizek = [@" " sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
                NSInteger countK = (int)ceilf(pVoice->stTitle.vTextItemList[i].nLength/sizek.width);
                for (int j =0 ; j < countK; j++)
                {
                    [strBegin appendString:@" "];
                    [string appendString:@" "];
                }
                
            }
                break;
            case PAGE_RICH_TEXT_PIECE_TEXT:
            {
                [string appendString:[NSString stringWithFormat:@"%@",[NSString stringWithUTF8String:pVoice->stTitle.vTextItemList[i].strText.c_str()]]];
                NSString * strText = [NSString stringWithFormat:@"<font color=\"%d,%d,%d,%d\">%@",pVoice->stTitle.vTextItemList[i].fontColor.rgbRed,pVoice->stTitle.vTextItemList[i].fontColor.rgbGreen,pVoice->stTitle.vTextItemList[i].fontColor.rgbBlue,pVoice->stTitle.vTextItemList[i].fontColor.rgbAlpha,[NSString stringWithUTF8String:pVoice->stTitle.vTextItemList[i].strText.c_str()]];
                [strBegin appendString:strText];
                [strFont setString:[NSString stringWithUTF8String:pVoice->stTitle.vTextItemList[i].fontFamily.c_str()]];
                fontsize = (float)pVoice->stTitle.vTextItemList[i].fontSize;
                
            }
                break;
            case PAGE_RICH_TEXT_PIECE_PARAGRAPH_END:
            {
                
            }
                break;
            case PAGE_RICH_TEXT_PIECE_DOT:
            {
                
            }
                break;
            default:
                break;
        }
    }
    [p setFont:strFont];
    [p setSize:fontsize];
    CGSize size = [string sizeWithFont:[UIFont fontWithName:strFont size:fontsize] constrainedToSize:CGSizeMake(SFSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    NSAttributedString *attString = [p attrStringFromMarkup:strBegin];
    ctv = [[CTView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [ctv setAttString:attString];
    [self addSubview:ctv];
    
    titHeight = size.height;
}

- (void)initTitle:(CGRect)frame
{
    musicTitle = [[UILabel alloc]init];
    musicTitle.backgroundColor = [UIColor clearColor];
    musicTitle.tag = MUSICTOOLVIEW_TITLE_TAG;
    musicTitle.numberOfLines = 0;
    [musicTitle setText:[NSString stringWithUTF8String:pVoice->strVoicePath.c_str()]];
    musicTitle.textAlignment = NSTextAlignmentLeft;
    CGSize sizeTt = [musicTitle.text sizeWithFont:QUESTION_TITLE_FONT constrainedToSize:CGSizeMake(FSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    musicTitle.frame = CGRectMake(0, 0, FSW, sizeTt.height+1);
    [self addSubview:musicTitle];
    titHeight = musicTitle.FSH;
 }

- (void)initButton:(CGRect)frame
{

    
    UIButton * b1 = [UIButton buttonWithType:UIButtonTypeCustom];
    b1.frame = CGRectMake(frame.size.width - 2*MUSICTOOLVIEW_BUTTON_HEIGHT_AND_WEIGHT,
        titHeight + (FSH - titHeight-MUSICTOOLVIEW_BUTTON_HEIGHT_AND_WEIGHT + MUSICTOOLVIEW_DISTANT)/2, MUSICTOOLVIEW_BUTTON_HEIGHT_AND_WEIGHT, MUSICTOOLVIEW_BUTTON_HEIGHT_AND_WEIGHT);
    UIImage * image = [UIImage imageNamed:@"m3.png"];
    [b1 setImage:image forState:UIControlStateNormal];
    [b1 addTarget:self action:@selector(pressSubClick:) forControlEvents:UIControlEventTouchUpInside];
    b1.backgroundColor = [UIColor grayColor];
    [self addSubview:b1];
    
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.backgroundColor  = [UIColor grayColor];
    nextButton.frame = CGRectMake(frame.size.width-MUSICTOOLVIEW_BUTTON_HEIGHT_AND_WEIGHT, ctv.frame.size.height + (frame.size.height - ctv.frame.size.height-MUSICTOOLVIEW_BUTTON_HEIGHT_AND_WEIGHT + MUSICTOOLVIEW_DISTANT)/2, MUSICTOOLVIEW_BUTTON_HEIGHT_AND_WEIGHT, MUSICTOOLVIEW_BUTTON_HEIGHT_AND_WEIGHT);
    [nextButton setImage:[UIImage imageNamed:@"m2.png"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(pressAddClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextButton];
    
    
    UIButton * startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.tag = MUSICTOOLVIEW_STARTBUTTON_TAG;
    startButton.backgroundColor  = [UIColor grayColor];
    startButton.frame = CGRectMake(0, ctv.frame.size.height + (frame.size.height - ctv.frame.size.height-MUSICTOOLVIEW_BUTTON_HEIGHT_AND_WEIGHT + MUSICTOOLVIEW_DISTANT)/2, MUSICTOOLVIEW_BUTTON_HEIGHT_AND_WEIGHT, MUSICTOOLVIEW_BUTTON_HEIGHT_AND_WEIGHT);
    [startButton addTarget:self action:@selector(playMusic:) forControlEvents:UIControlEventTouchUpInside];
    startButton.selected = NO;
    [startButton setImage:[UIImage imageNamed:@"g_music_play.png"] forState:UIControlStateNormal
     ];
    [self addSubview:startButton];
}

-(void)sliderVolume:(CGRect)frame
{
    UISlider * slider = [[UISlider alloc]init];
    slider.backgroundColor = [UIColor grayColor];
    //    高度无效
    slider.frame = CGRectMake(MUSICTOOLVIEW_BUTTON_HEIGHT_AND_WEIGHT, titHeight + (FSH - titHeight-MUSICTOOLVIEW_BUTTON_HEIGHT_AND_WEIGHT + MUSICTOOLVIEW_DISTANT)/2, FSW-3*MUSICTOOLVIEW_BUTTON_HEIGHT_AND_WEIGHT, MUSICTOOLVIEW_SLIDER_HEIGHT);
    //    设定滚动条位置 ,默认最小值0，默认最大值1.0
    slider.value = 0.0f;
    //左侧颜色
    [slider setMinimumTrackTintColor:[UIColor blueColor]];
    //右侧颜色
    [slider setMaximumTrackTintColor:[UIColor lightGrayColor]];
    [slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    slider.tag = 521;
    [self addSubview:slider];
    [slider release];
}

static float value;
-(void)pressAddClick:(id)sender
{
    UISlider * slider = (UISlider *)[self viewWithTag:521];
    value = 0.01;
    if (1.0 > slider.value && slider.value >= 0)
    {
        slider.value =  value + slider.value;
        mp3Player.currentTime = slider.value * mp3Player.duration;
    }
}

-(void)pressSubClick:(id)sender
{
    UISlider * slider = (UISlider *)[self viewWithTag:521];
    
    if (1.0 > slider.value && slider.value >= value)
    {
        slider.value =  slider.value - value ;
        mp3Player.currentTime = slider.value * mp3Player.duration;
    }
}

-(void)sliderChange:(id)sender
{
    UISlider * slider = (UISlider *)[self viewWithTag:521];
    mp3Player.currentTime = slider.value * mp3Player.duration;
    
}
-(void)myTimer:(id)arg
{
    float t = mp3Player.duration;
    float t2 = mp3Player.currentTime;
    UISlider * slider = (UISlider *)[self viewWithTag:521];
    slider.value = t2/t;
}

-(void)mp3Player:(NSString *)musicName
{
    NSString *path = [[[[DOCUMENT stringByAppendingPathComponent:BOOKNAME] stringByAppendingPathComponent:@"OPS"] stringByAppendingPathComponent:@"medias"] stringByAppendingPathComponent:musicName];
    NSURL * url = [NSURL fileURLWithPath:path];
    mp3Player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
}

static int pressIndexNum;
-(void)playMusic:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected && pressIndexNum == 0)
    {
    [mp3Player prepareToPlay];
    [mp3Player play];
    }
    else if(!button.selected)
    {
        UIButton *pauseButton = (UIButton *)[self viewWithTag:MUSICTOOLVIEW_STARTBUTTON_TAG];
        [pauseButton setImage:[UIImage imageNamed:@"g_music_pause.png"] forState:UIControlStateNormal];
        [pauseButton addTarget:self action:@selector(pauseClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (button.selected)
    {
        UIButton *continueButton = (UIButton *)[self viewWithTag:MUSICTOOLVIEW_STARTBUTTON_TAG];
        [continueButton setImage:[UIImage imageNamed:@"g_music_play.png"] forState:UIControlStateNormal];
        [continueButton addTarget:self action:@selector(continueClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    pressIndexNum++;
}

-(void)pauseClick:(id)sender
{
    [mp3Player pause];
}

-(void)continueClick:(id)sender
{
    [mp3Player play];
}

- (void)stop
{
[mp3Player pause];
}

@end
