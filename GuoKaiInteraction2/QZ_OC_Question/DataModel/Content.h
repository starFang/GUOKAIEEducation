
#define DOCUMENT [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define BOOKNAME @"GuoKai001"

#pragma mark - 单页显示的TAG值
#define TOOLTIP 40
#define TOOLIMAGETIP 90
#define NAVRECT 140
#define NAVBUTTON 190
#define VIDEO 240
#define QUESTION 290
#define IMAGE 340
#define IMAGELIST 390
#define VOICE 440
#define TEXTROLL 490
#define WEBLINK 540

#pragma mark - 显示控制QZRootViewController
#define PAGELISTVIEW_ON_QZROOT_TAG 200
#define QZDIRECTANDBMARKANDNOTESVIEW_TAG 250
#define UPANDDOWN_ADD_BOOKMARK_SC_TAG 300
#define LEFTANDRIGHT_PAGE_CONTROL_SC_TAG 400
#define BOOKMARK_IMAGE_TAG 450



#pragma mark - 单页的画线操作
#define RED 100
#define BLUE 110
#define PURPLE 120
//画线视图
#define DRAWVIEWTAG 600
//按钮弹出框
#define POPBTNVIEW 610
//笔记按钮
#define NOTEBTN 620
#define NOTE_LINECOLOR_DELETE_MENU 730
#define NOTE_POP_VIEW 830

//主要是QZPageListView上的点击弹出按钮的操作的TAG值
#define NVACHILDBUTTON 120

#pragma mark - 简单的替换
#define SFSW self.frame.size.width
#define SFSH self.frame.size.height
#define FSH frame.size.height
#define FSW frame.size.width
#define FOX frame.origin.x
#define FOY frame.origin.y
#define SFOX self.frame.origin.x
#define SFOY self.frame.origin.y
#define DW 1024.0
#define DH 768.0
#define ZERO 0
#pragma mark - 字号和字体
#define QUESTION_TITLE_FONT [UIFont fontWithName:@"Helvetica" size:15]
#define QUESTION_NUMBER_OF_QUESTIONS_FONT [UIFont fontWithName:@"Helvetica Neue" size:17]
#define QUESTION_TOPIC_FONT [UIFont fontWithName:@"Palatino" size:18]
#define QUESTION_ANSWER_FONT [UIFont fontWithName:@"Palatino" size:20]


#pragma mark - 点击提示框
#define TIP_BUTTON_POP_ON_BTN_HEIGHT 10
#define TIP_BUTTON_POP_THE_BTN_HEIGHT 60
//点击提示框的上下距离
#define TIP_POP_HEIGHT_OF_TAP 30

#pragma mark - RichText 富文本类型
#pragma mark - 音频
#define MUSICTOOL_START_BTN_TAG 270
#define MUSICTOOLVIEW_SIZE_WIDTH 275
#define MUSICTOOLVIEW_SIZE_WEIGHT 85 //音乐播放器的最小高和宽
#define MUSICTOOLVIEW_TITLE_TAG 10 //标题的TAG值
#define MUSICTOOLVIEW_SLIDER_HEIGHT 20
#define MUSICTOOLVIEW_BUTTON_HEIGHT_AND_WEIGHT 20 //按钮的宽和高
#define MUSICTOOLVIEW_DISTANT 10 //音乐播放器之间的距离差
#define MUSICTOOLVIEW_STARTBUTTON_TAG 20

#pragma mark - 视频
#define MOVIEVIEW_TITLE_TAG 30 //标题的TAG值
#define MOVIEVIEW_DISTANT 10 //标题和视频间的距离

#pragma mark - 画廊
#define HUALANG_FOOTLABEL_TAG 888 //全屏状态下得画廊得详细说明
#define HUALANG_SC_TAG 887        //画廊全屏的tag值
#define HUALANG_BCAKVIEW_TAG 886  //画廊全屏下的值

#pragma mark - 单张图片
#define IMAGEOFONE 885


#pragma mark - 习题
#define QUESTION_UPANDNEXT_WIDTH  60
#define QUESTION_UPANDNEXT_HEIGHT 30
#define QUESTION_ANSWERBUTTON_WIDTH 110
#define QUESTION_DISTANT 10
#define QUESTION_TITLELABEL_TAG 100
#define QUESTION_SCV_TAG 110 //滚动视图的tag值
#define QUESTION_UPBUTTON_TAG 111
#define QUESTION_NEXTBUTTON_TAG 113
#define QUESTION_ANSWERBUTTON_TAG 112
#define QUESTION_ANSWER_BUTTON_CHOICE_TAG 120
#define QUESTION_CONTENT_VIEW_TAG 130
#define QUESTION_AGAIN_ONCE_TAG 140

#pragma mark - 连线题
#define QUESTION_LINE_RIGHT_BUTTON_TAG 200
#define QUESTION_LINE_LEFT_BUTTON_TAG  250
#define QUESTION_LINE_VIEW_TAG 230
#define QUESTION_LINE_WIDTH 2

#pragma mark - 文字拖动到图片题
#define QUESTION_DRAGTOPONT_VIEW_TAG 330
#define QUESTION_DRAGTOPOINT_ANSWER_LABELWITHIMAGE_TAG 100
#define QUESTION_DRAGTOPOINT_ANSWER_IMAGE_HEIGHT 35
#define QUESTION_DRAGTOPOINT_ANSWER_IMAGE_VIEW_TAG 150
#define QUESTION_DRAGTOPOINT_ANSWER_W_AND_H 40

#pragma mark - 简答题
#define QUESTION_BRIEFANSWER_VIEW_TAG 430
#define QUESTION_BRIEFANSWER_TEXTVIEW_TAG 100
#define QUESTION_BRIEFANSWER_INPUT_ANSWER_SCV_TAG 110
#define QUESTION_BRIEFANSWER_ANSWER_SCV_TAG 120
#define QUESTION_BRIEFANSWER_ANSWER_TITLELABEL_TAG 121
#define QUESTION_BRIEFANSWER_ANSWER_SCANDINPUT_TV_DISTANT 5

#pragma mark - 排序题
#define QUESTION_SORT_VIEW_TAG 530

#pragma mark - 图像选择题
#define QUESTION_IMAGE_SELECTED_VIEW_TAG 630
#define QUESTION_ANSWER_IMAGE_BUTTON_TAG 100
#define QUESTION_SMALL_IMAGE_HEIGHT_AND_WIDTH 30
#define QUESTION_SMALL_IMAGE_TAG 200

#pragma mark - 填空题
#define QUESTION_FILLBLANK_VIEW_TAG 730
#define QUESTION_FILLBLANK_INPUTSCV_TAG 100
#define QUESTION_FILLBLANK_INPUT_ANSWER_SCV_TAG 110
#define QUESTION_FILLBLANK_INPUT_LABEL_TAG 66
#define QUESTION_FILLBLANK_ANSWER_SCV_TAG 333