//
//  RootViewController.m
//  QuestionDemo
//
//  Created by qanzone on 13-10-8.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "RootViewController.h"
#import "QuestionRootView.h"

//文字拖动题DataModel头文件
#import "PageQuestionDrag1.h"
#import "PageQuestionDragPoint1.h"
//填空题DataModel头文件
#import "PageQuestionBriefAnswer1.h"
//选择题DataModel头文件
#import "PageQuestionChoice1.h"
//连线题DataModel头文件
#import "PageQuestionConnection1.h"
//排序题DataModel头文件
#import "PageQuestionSort1.h"
//图像选择题Datamodel头文件
#import "PageQuestionImageSelect1.h"
//填空题Datamodel头文件
#import "PageQuestionFillBlank1.h"
#import "PageQuestionFillBlankItem1.h"


@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initCreateData];
    
    self.view.backgroundColor = [UIColor orangeColor];
    CGPoint p1 = CGPointMake(112, 74);
    CGPoint p2 = CGPointMake(112+800, 74+600);
    QuestionRootView *qView = [[QuestionRootView alloc]initWithFrame:CGRectMake(p1.x ,p1.y,p2.x-p1.x,p2.y-p1.y)];
    [qView setQList:qListData];
    [qView composition];
    [self.view addSubview:qView];
}


#pragma mark - 创造假数据

- (void)initCreateData
{
    [self creatQuestionData];
    [self creatQuestionChoiceData];
    [self creatQuestionConnectionData];
    [self createDragToPointData];
    [self createBriefAnswerWithData];
    [self creatQuestionSortData];
    [self creatQuestionFillBlankData];
    [self creatQuestionImageSelectData];
}

- (void)creatQuestionData
{
  qListData = [[PageQuestionList1 alloc]init];
    NSString *titleName = @"测试3.1 课后练习";
    [qListData setTitleName:titleName];
    
}

- (void)creatQuestionChoiceData
{
    for (int i = 0; i <5; i++)
    { 
        PageQuestionChoice1 *pqc = [[PageQuestionChoice1 alloc]init];
        pqc.eType = PAGE_QUESTION_CHOICE;
        [pqc setStrQuestion:[NSString stringWithFormat:@"第%d题 请从下面选出你最喜欢的城市？",i+1]];
        NSMutableArray *array = [NSMutableArray array];
        for (int j = 0; j < i+1 ; j++)
        {
            NSString *str = [NSString stringWithFormat:@"灵台无计逃神矢，风雨如磐暗故园。寄意寒星荃不察，我以我血荐轩辕。自问数十年来，于自己保存之外，也时时想到中国，想到未来，愿为大家出一点微力，都可以自白的。%d",j+1];
            [array addObject:str];
        }
        [pqc setVChoices:array];
        if (i == 0) {
            [pqc setVAnswer:[NSMutableArray arrayWithObject:@"0"]];
        }else if (i == 1){
            [pqc setVAnswer:[NSMutableArray arrayWithObject:@"0"]];
        }else if (i == 2){
            [pqc setVAnswer:[NSMutableArray arrayWithObject:@"1"]];
        }else if (i == 3){
            [pqc setVAnswer:[NSMutableArray arrayWithObject:@"2"]];
        }else if (i == 4){
            [pqc setVAnswer:[NSMutableArray arrayWithObjects:@"2",@"3", nil]];
        }
        [qListData.vQuestions addObject:pqc];
        [pqc release];
    }
}

- (void)creatQuestionConnectionData
{
    for (int i = 0; i < 5; i++)
    {
        PageQuestionConnection1 * pqc = [[PageQuestionConnection1 alloc]init];
        pqc.eType = PAGE_QUESTION_CONNECTION;
        [pqc setStrQuestion:[NSString stringWithFormat:@"第%d题 请将下面省份对应的省会连起来",i+1]];
        
        NSMutableArray *arrayL = [NSMutableArray arrayWithObjects:@"河北省",@"湖南省",@"黑龙江省",@"云南省",@"新疆", nil];
        NSMutableArray *arrayR = [NSMutableArray arrayWithObjects:@"长沙",@"昆明",@"哈尔滨",@"拉萨",@"石家庄", nil];
        [pqc setVLeftSide:arrayL];
        [pqc setVRightSide:arrayR];
        [pqc setVAnswers:[[NSMutableArray alloc]initWithObjects:@"4",@"0",@"2",@"1",@"3", nil]];
        [qListData.vQuestions addObject:pqc];
        [pqc release];
    }

 }

- (void)createDragToPointData
{
    for (int i = 0; i < 5; i++)
    {
        PageQuestionDrag1 *dragQuestion = [[PageQuestionDrag1 alloc]init];
        dragQuestion.eType = PAGE_QUESTION_DRUG;
        [dragQuestion setStrBackGroundImage:[NSString stringWithFormat:@"1_%d.jpg",i+1]];
        [dragQuestion setStrQuestion:[NSString stringWithFormat: @"第%d题 下面你将看到的建筑，那个国家的那个城市？",i+1]];
        NSMutableArray * array = [NSMutableArray array];
        for (int j = 0; j < i+2 ; j++)
        {
            QZ_BOX1 *rect = [[QZ_BOX1 alloc]init];
            if (i%2==0)
            {
                [rect setX0:j*50.0];
                [rect setX1:(j+1)*50.0];
                [rect setY0:j*50.0];
                [rect setY1:(j+1)*50.0];
            }else{
                [rect setX0:500 + j*50.0];
                [rect setX1:500 + (j+1)*50.0];
                [rect setY0:j*50.0];
                [rect setY1:(j+1)*50.0];
            }
            PageQuestionDragPoint1 *dragpoint = [[PageQuestionDragPoint1 alloc]init];
            [dragpoint setNAnswer:i+1-j];
            [dragpoint setRect:rect];
            [array addObject:dragpoint];
        }
        [dragQuestion setVImageSide:array];
        
        NSMutableArray * arraySide = [NSMutableArray arrayWithObjects:@"法国",@"中国",@"北京",@"马赛",@"America",@"Japan",@"England", nil];
        NSMutableArray *arrayS = [NSMutableArray array];
        for (int j = 0; j < i+2; j++)
        {
            [arrayS addObject:[arraySide objectAtIndex:j]];
        }
        [dragQuestion setVStringSide:arrayS];
        [qListData.vQuestions addObject:dragQuestion];
    }

}

- (void)createBriefAnswerWithData
{
    for (int i = 0; i < 5; i++)
    {
        PageQuestionBriefAnswer1 *qbf = [[PageQuestionBriefAnswer1 alloc]init];
        qbf.eType = PAGE_QUESTION_BRIEF_ANSWER;
        if (i < 2)
        {
            [qbf setStrQuestion:[NSString stringWithFormat:@"第%d题 请输入你的人生计划，你的未来五年的计划，你的梦想？",i+1]];
            [qbf setStrAnswer:@"\nI am not unmindful that some of you have come here out of great trials and tribulations. Some of you have come fresh from narrow jail cells. And some of you have come from areas where your quest -- quest for freedom left you battered by the storms of persecution and staggered by the winds of police brutality. You have been the veterans of creative suffering. Continue to work with the faith that unearned suffering is redemptive. Go back to Mississippi, go back to Alabama, go back to South Carolina, go back to Georgia, go back to Louisiana, go back to the slums and ghettos of our northern cities, knowing that somehow this situation can and will be changed.\nLet us not wallow in the valley of despair, I say to you today, my friends.\nAnd so even though we face the difficulties of today and tomorrow, I still have a dream. It is a dream deeply rooted in the American dream.\nI have a dream that one day this nation will rise up and live out the true meaning of its creed: \"We hold these truths to be self-evident, that all men are created equal.\"\nI have a dream that one day on the red hills of Georgia, the sons of former slaves and the sons of former slave owners will be able to sit down together at the table of brotherhood.\nI have a dream that one day even the state of Mississippi, a state sweltering with the heat of injustice, sweltering with the heat of oppression, will be transformed into an oasis of freedom and justice.\nI have a dream that my four little children will one day live in a nation where they will not be judged by the color of their skin but by the content of their character.\nI have a dream today!\\nI have a dream that one day, down in Alabama, with its vicious racists, with its governor having his lips dripping with the words of \"interposition\" and \"nullification\" -- one day right there in Alabama little black boys and black girls will be able to join hands with little white boys and white girls as sisters and brothers.\nI have a dream today!\nI have a dream that one day every valley shall be exalted, and every hill and mountain shall be made low, the rough places will be made plain, and the crooked places will be made straight; \"and the glory of the Lord shall be revealed and all flesh shall see it together."];
        }else{
            [qbf setStrQuestion:[NSString stringWithFormat:@"第%d题 灵台无计逃神矢，风雨如磐暗故园。寄意寒星荃不察，我以我血荐轩辕。作何感想？",i+1]];
            
            NSMutableArray * array = [[NSMutableArray alloc]initWithObjects:@"灵台无计逃神矢，风雨如磐暗故园。寄意寒星荃不察，我以我血荐轩辕。",@"轩辕，即轩辕黄帝，中华民族的始祖，在这里代指中华民话。",@"1.我以我血荐轩辕的意思就是我要用我的血来表达对中华民族的深爱。\n2.自问数十年来，于自己保存之外，也时时想到中国，想到未来，愿为大家出一点微力，都可以自白的。\n3.先生的遗容像下这段自我评价的文字，朴实无华却字字千钧。“民族魂”（沈钧儒手书）\n4.没有伟大人物出现的民族，是世界上最可怜的生物之群；有了伟大的人物，而不知拥护、爱戴、崇仰的国家，是没有希望的奴隶之邦。因鲁迅之一死，使人们自觉出了民族的尚可以有为；也因鲁迅之一死，使人家看出了中国还是奴隶性很浓厚的半绝望的国家。\n", nil];
            [qbf setStrAnswer:[array objectAtIndex:i-2]];
        }
        [qListData.vQuestions addObject:qbf];
    }
}

- (void)creatQuestionSortData
{
    for (int i = 0 ; i < 5; i++)
    {
        PageQuestionSort1 *pqs = [[PageQuestionSort1 alloc]init];
        pqs.eType = PAGE_QUESTION_SORT;
        if (i == 0)
        {
            [pqs setStrQuestion:@"1.2009年12月，藏羚羊基因组序列图谱在青海大学医学院宣告绘制完成。将下面4个句子重新排序，使之与前一部分文字组合完整。"];
            NSMutableArray * array = [NSMutableArray arrayWithObjects: @"①藏羚羊是中国青藏高原特有的物种，是研究低氧适应性的极佳模式动物，具有珍贵的进化研究价值",@"②并且，有助于从根本上改善高原居民尤其是青藏高原藏族等世居少数民族的生存状态",@"③专家认为，此图谱的绘制完成，将为破译慢性高原病发病机制提供科学依据",@"④这是世界上第一部高原濒危物种全基因组序列图谱，也是中国科学家对全球基因组科学的又一重大贡献", nil];
            [pqs setVStrTexts:array];
            [pqs setVSortedList:[NSMutableArray arrayWithObjects:@"3",@"1",@"2",@"0", nil]];
        }
        else if (i == 1)
        {
            [pqs setStrQuestion:@"2.对下面语句正确排序"];
            NSMutableArray * array = [NSMutableArray arrayWithObjects: @"①对发展中国家和新兴市场国家尤其如此",@"②很大原因是因为中国仍然保持着对资本流动的严格控制",@"③作为一个发展中国家，中国之所以在过去这些年屡屡可以躲过金融危机的直接冲击",@"④资本的自由流动，从来都是一把双刃剑",@"⑤一个原因就是这些国家尚不成熟的金融体系碰上了具有高度流动性的国际资本",@"⑥这个世界上几乎还没有哪个新兴市场国家逃脱过金融危机的魔爪", nil];
            [pqs setVStrTexts:array];
            [pqs setVSortedList:[NSMutableArray arrayWithObjects:@"2",@"1",@"3",@"0",@"5",@"4", nil]];
        }
        else if (i == 2)
        {
            [pqs setStrQuestion:@"3.将以下6个句子重新排列组合,排列组合最连贯的是："];
            NSMutableArray * array = [NSMutableArray arrayWithObjects: @"①任何心理活动，任何创作，也许都具有“一次性”。",@"②揣度别人是很困难的。子非鱼，安知鱼之乐?",@"③作者的回顾，事后的创作谈，能在多大程度上与实际创作情状符合，是值得怀疑的。",@"④甚至揣度自己也未见得容易多少。",@"⑤人不能把脚两次伸进同一条河里。",@"⑥比方说这篇小说写过这么久了，尽管我现在能尽力回忆当时写作的心境，但时过境迁，当时的心境是绝对不可能再完整准确地重现了。", nil];
            [pqs setVStrTexts:array];
            [pqs setVSortedList:[NSMutableArray arrayWithObjects:@"1",@"3",@"5",@"2",@"4",@"0", nil]];
        }
        else if (i == 3)
        {
            [pqs setStrQuestion:@" 4.依次填入下面一段文字横线处的语句，衔接最恰当的一项是：\n衡水，古时地处燕南赵北，东与齐鲁接壤，历来是燕赵文化和齐鲁文化的交汇处，千百年来，() ，() ， () ，() ：() ，() ，文能治国的宰相，武能安邦的将帅;有著书立说的思想家，发明创造的科学家，开馆讲学的教育家，蜚声文坛的文学家，造诣深厚的艺术家;还有乐善好施、急公好义的仁人，侠肝义胆、见义勇为的志士，以及叱咤风云、反抗暴政的农民起义领袖等等。"];
            NSMutableArray * array = [NSMutableArray arrayWithObjects: @"①母仪天下的太后”。",@"②名贤俊杰史不绝书",@"③人文资源丰富",@"④有主政一国的帝王",@"⑤得文化发展风气之先",@"⑥文化积淀厚重", nil];
            [pqs setVStrTexts:array];
            [pqs setVSortedList:[NSMutableArray arrayWithObjects:@"4",@"5",@"2",@"1",@"3",@"0", nil]];
        }
        else if (i == 4)
        {
            [pqs setStrQuestion:@" 5.给下列句子排序:"];
            NSMutableArray * array = [NSMutableArray arrayWithObjects: @"①当阳光洒在身上时，它更坚定了心中的信念——要开出：一朵鲜艳的花。”。",@"②不久，它从泥土里探出了小脑袋，渐渐地，种子变成了嫩芽。",@"③从此，它变得沉默，只有它知道它在努力，它在默默地汲取土壤中的养料。",@"④虽然它经受着黑暗的恐惧，暴雨的侵袭，但是它依然努力地生长着。",@"⑤种子在这块土地上的生活并不那么顺利，周围的各种杂草都嘲笑它，排挤它，认为它只是一粒平凡的种子。", nil];
            [pqs setVStrTexts:array];
            [pqs setVSortedList:[NSMutableArray arrayWithObjects:@"4",@"2",@"3",@"1",@"0", nil]];
        }
        [qListData.vQuestions addObject:pqs];
        [pqs release];
    }
}

- (void)creatQuestionImageSelectData
{
    for (int i = 0; i < 5; i ++)
    {
        PageQuestionImageSelect1 * pqis = [[PageQuestionImageSelect1 alloc]init];
        pqis.eType = PAGE_QUESTION_IMAGE_CHOICE;
        if (i == 0) {
            [pqis setStrQuestion:@"1. 男：今天冷啊！\n男：看那个美女，穿的好火热啊！\n问这两男的的是什么意思？"];
            [pqis setVAnswers:[NSMutableArray arrayWithObject:@"1"]];
            [pqis setVStrImage:[NSMutableArray arrayWithObjects:@"1_1.jpg",@"1_1.jpg",nil]];
        }else if (i == 1){
            [pqis setStrQuestion:@"2. 男：看那个妹妹，好靓哦！\n女：看你个大头鬼！\n问：这个女的是什么意思？"];
            [pqis setVAnswers:[NSMutableArray arrayWithObject:@"1"]];
            [pqis setVStrImage:[NSMutableArray arrayWithObjects:@"1_2.jpg",@"1_3.jpg",@"1_4.jpg",nil]];
            
        }else if (i == 2){
            [pqis setStrQuestion:@"3. 男：我把捡来的钱包交给警察了。\n男：我KAO！\n问：第二个人什么意思？"];
            [pqis setVAnswers:[NSMutableArray arrayWithObject:@"0"]];
            [pqis setVStrImage:[NSMutableArray arrayWithObjects:@"1_1.jpg",@"1_2.jpg",@"1_3.jpg",@"1_4.jpg",nil]];
            
        }else if (i == 3){
            [pqis setStrQuestion:@"4. 老师： 为什么你们考的这么烂？\n问：听众可能是谁？"];
            [pqis setVAnswers:[NSMutableArray arrayWithObjects:@"1",@"3", nil]];
            [pqis setVStrImage:[NSMutableArray arrayWithObjects:@"1_1.jpg",@"1_2.jpg",@"1_3.jpg",@"1_4.jpg",@"1_5.jpg",nil]];
            
        }else if (i == 4){
            [pqis setStrQuestion:@"5. 下面问题根据这篇录音出：\n女： 您好 ，您拨叫的用户没有开机，要留言请留言，不留言请挂机。\n问：1）这是发生在什么时候？"];
            [pqis setVAnswers:[NSMutableArray arrayWithObjects:@"2",@"4", nil]];
            [pqis setVStrImage:[NSMutableArray arrayWithObjects:@"1_1.jpg",@"1_2.jpg",@"1_3.jpg",@"1_4.jpg",@"1_5.jpg",@"1_6.jpg",nil]];
        }
        
        [qListData.vQuestions addObject:pqis];
        [pqis release];
    }
}

- (void)creatQuestionFillBlankData
{
    for (int i = 0; i < 5; i++)
    {
        PageQuestionFillBlank1 *qfb = [[PageQuestionFillBlank1 alloc]init];
        qfb.eType = PAGE_QUESTION_FILE_BLANK;
        if (i == 0)
        {
            for (int j = 0; j < 5; j++)
            {
                
                PageQuestionFillBlankItem1 *pqfb = [[PageQuestionFillBlankItem1 alloc]init];
                if (j == 0) {
                    [pqfb setIsAnswer:NO];
                    [pqfb setStrText:@"1.唯物辩证法的两大特征是"];
                }else if (j == 1)
                {
                    [pqfb setStrText:@"普遍联系"];
                    [pqfb setIsAnswer:YES];
                }else if (j == 2){
                    [pqfb setStrText:@"和"];
                    [pqfb setIsAnswer:NO];
                }else if (j == 3){
                    [pqfb setStrText:@"永恒发展"];
                    [pqfb setIsAnswer:YES];
                }else if (j == 4){
                    [pqfb setStrText:@"。"];
                    [pqfb setIsAnswer:NO];
                }
                [qfb.vDescription addObject:pqfb];
                [pqfb release];
            }
        }else if (i == 1){
            
            for (int j = 0; j < 11; j++)
            {
                PageQuestionFillBlankItem1 *pqfb = [[PageQuestionFillBlankItem1 alloc]init];
                if (j == 0) {
                    [pqfb setIsAnswer:NO];
                    [pqfb setStrText:@"2. 唯物辩证法的基本范畴有"];
                }else if (j == 1)
                {
                    [pqfb setStrText:@"原因与结果"];
                    [pqfb setIsAnswer:YES];
                }else if (j == 2){
                    [pqfb setStrText:@"、"];
                    [pqfb setIsAnswer:NO];
                }else if (j == 3){
                    [pqfb setStrText:@"必然性与偶然性"];
                    [pqfb setIsAnswer:YES];
                }else if (j == 4){
                    [pqfb setStrText:@"、"];
                    [pqfb setIsAnswer:NO];
                }else if (j == 5)
                {
                    [pqfb setStrText:@"可能性与现实性"];
                    [pqfb setIsAnswer:YES];
                }else if (j == 6){
                    [pqfb setStrText:@"、"];
                    [pqfb setIsAnswer:NO];
                }else if (j == 7){
                    [pqfb setStrText:@"现象与本质"];
                    [pqfb setIsAnswer:YES];
                }else if (j == 8){
                    [pqfb setStrText:@"、"];
                    [pqfb setIsAnswer:NO];
                }else if (j == 9){
                    [pqfb setStrText:@"内容与形式"];
                    [pqfb setIsAnswer:YES];
                }else if (j == 10){
                    [pqfb setStrText:@"。"];
                    [pqfb setIsAnswer:NO];
                }
                [qfb.vDescription addObject:pqfb];
                [pqfb release];
            }
            
        }else if (i == 2){
            for (int j = 0; j < 5; j++)
            {
                
                PageQuestionFillBlankItem1 *pqfb = [[PageQuestionFillBlankItem1 alloc]init];
                if (j == 0) {
                    [pqfb setIsAnswer:NO];
                    [pqfb setStrText:@"3. "];
                }else if (j == 1)
                {
                    [pqfb setStrText:@"归纳"];
                    [pqfb setIsAnswer:YES];
                }else if (j == 2){
                    [pqfb setStrText:@"与"];
                    [pqfb setIsAnswer:NO];
                }else if (j == 3){
                    [pqfb setStrText:@"演绎"];
                    [pqfb setIsAnswer:YES];
                }else if (j == 4){
                    [pqfb setStrText:@"是人类思维从个别到一般，又由一般到个别的最常见的推理形式。"];
                    [pqfb setIsAnswer:NO];
                }
                [qfb.vDescription addObject:pqfb];
                [pqfb release];
            }
            
        }else if (i == 3){
            for (int j = 0; j < 5; j++)
            {
                
                PageQuestionFillBlankItem1 *pqfb = [[PageQuestionFillBlankItem1 alloc]init];
                if (j == 0) {
                    [pqfb setIsAnswer:NO];
                    [pqfb setStrText:@"4. "];
                }else if (j == 1)
                {
                    [pqfb setStrText:@"矛盾的同一性"];
                    [pqfb setIsAnswer:YES];
                }else if (j == 2){
                    [pqfb setStrText:@"是矛盾双方相互依存、相互贯通的性质和趋势。"];
                    [pqfb setIsAnswer:NO];
                }else if (j == 3){
                    [pqfb setStrText:@"矛盾的斗争性"];
                    [pqfb setIsAnswer:YES];
                }else if (j == 4){
                    [pqfb setStrText:@"是矛盾着的对立面之间相互排斥、相互分离的性质与趋势。"];
                    [pqfb setIsAnswer:NO];
                }
                [qfb.vDescription addObject:pqfb];
                [pqfb release];
            }
        }else if (i == 4){
            for (int j = 0; j < 9; j++)
            {
                PageQuestionFillBlankItem1 *pqfb = [[PageQuestionFillBlankItem1 alloc]init];
                if (j == 0) {
                    [pqfb setIsAnswer:NO];
                    [pqfb setStrText:@"5. Boston Globe reporter Chris Reidy notes that the situation will improve only when there are"];
                }else if (j == 1)
                {
                    [pqfb setStrText:@"comprehensive"];
                    [pqfb setIsAnswer:YES];
                }else if (j == 2){
                    [pqfb setStrText:@"programs that address the many needs of the homeless."];
                    [pqfb setIsAnswer:NO];
                }else if (j == 3){
                    [pqfb setStrText:@"As"];
                    [pqfb setIsAnswer:YES];
                }else if (j == 4){
                    [pqfb setStrText:@"Edward Blotkowsk, director of community service at Bentley College in Massachusetts,"];
                    [pqfb setIsAnswer:NO];
                }else if (j == 5)
                {
                    [pqfb setStrText:@"puts"];
                    [pqfb setIsAnswer:YES];
                }else if (j == 6){
                    [pqfb setStrText:@"it, \"There has to be"];
                    [pqfb setIsAnswer:NO];
                }else if (j == 7){
                    [pqfb setStrText:@"coordination"];
                    [pqfb setIsAnswer:YES];
                }else if (j == 8){
                    [pqfb setStrText:@"of programs. What's need is a package deal.\" "];
                    [pqfb setIsAnswer:NO];
                }
                [qfb.vDescription addObject:pqfb];
                [pqfb release];
            }
        }
        [qListData.vQuestions addObject:qfb];
        [qfb release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [qListData release];
    [super dealloc];
}

@end
