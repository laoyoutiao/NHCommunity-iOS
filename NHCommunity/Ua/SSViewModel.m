//
//  ViewModel.m
//  NHCommunity
//
//  Created by aa on 16/3/17.
//  Copyright © 2016年 ku. All rights reserved.
//

#import "SSViewModel.h"
#import "Constant.h"
#import "StaffIconModel.h"

typedef void(^IconClickBlock)(StaffIconModel *smodel,NSInteger clickIndex);

@interface SSViewModel(){
    UIView *_headerView;
    UILabel *_middelView;
    UIView *_opView;
    UIView *_serviceView;
    NSMutableArray *_opDataSource;
    NSMutableArray *_serviceDataSource;
    UIView *_bookView;
}
@property (nonatomic, copy) IconClickBlock opBlk;
@property (nonatomic, copy) IconClickBlock ssBlk;

@property (nonatomic, copy) IconClickBlock bookBlk;

@end

@implementation SSViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self genDataSource];
    }
    return self;
}

- (void)genDataSource{
    _opDataSource = [[NSMutableArray alloc] initWithCapacity:3];
    _serviceDataSource = [[NSMutableArray alloc] initWithCapacity:8];
    NSArray *className = @[@"JoinInTableViewController",
                           @"StaffAskTableViewController",
                           @"WebDetailOnlyByLinkViewController"];
    NSArray *titleName = @[@"我要入会",
                           @"我要咨询",
                           @"我要调解"];
    NSArray *iconName = @[@"wyrh.png",@"wyzx.png",@"wytj.png"];
    for ( int i = 0; i < 3; i++) {
        StaffIconModel *model = [[StaffIconModel alloc] init];
        [model setIcon:iconName[i]];
        [model setTitle:titleName[i]];
        [model setTargetController:className[i]];
        if (i != 2) {
            [model setLogin:YES];
        }
        if (i == 2) {
            [model setUrl:@"http://staffhome.nanhai.gov.cn/aytj.jhtml"];
        }
        [_opDataSource addObject:model];
    }
    
    NSArray *className1 = @[@"WebDetailOnlyByLinkViewController",
                            @"WebDetailOnlyByLinkViewController",
                            @"WebDetailOnlyByLinkViewController",
                            @"WebDetailOnlyByLinkViewController",
                            @"WebDetailOnlyByLinkViewController",
                            @"LaoDongBHViewController",
                            @"WenTJJViewController",
                            @"WebDetailOnlyByLinkViewController",
                            @"WebDetailOnlyByLinkViewController"];
    NSArray *titleName1 = @[@"办事流程",@"困难帮扶",@"法律服务",@"医疗互助",@"劳动竞赛",@"劳动保护",@"文体推介",@"便民服务",@"职工超市"];
    NSArray *iconName1 = @[@"bslc.png",@"knbf.png",@"flfw.png",@"ylhz.png",@"ldjs.png",@"ldbh.png",@"wttj.png",@"bmfw.png",@"zgcs.png"];
    for ( int i = 0; i < iconName1.count; i++) {
        StaffIconModel *model = [[StaffIconModel alloc] init];
        [model setIcon:iconName1[i]];
        [model setTitle:titleName1[i]];
        [model setTargetController:className1[i]];
        
        if (i == 1) {
            [model setUrl:@"http://staffhome.nanhai.gov.cn/knbf/index.jhtml"];
        }else if (i == 2){
            [model setUrl:@"http://staffhome.nanhai.gov.cn/applsfw/index.jhtml"];
        }else if (i == 3){
            [model setUrl:@"http://staffhome.nanhai.gov.cn/ylhz/index.jhtml"];
        }else if (i == 4){
            [model setUrl:@"http://staffhome.nanhai.gov.cn/lmjs/index.jhtml"];
        }else if (i == 7){
            [model setUrl:@"http://staffhome.nanhai.gov.cn/appbmfw/index.jhtml"];
        }else if (i == 8){
            [model setUrl:@"http://staffhome.nanhai.gov.cn/appshop.jhtml"];
        }else if (i == 0){
            [model setUrl:@"http://staffhome.nanhai.gov.cn/bslc.jhtml"];
        }
        
        [_serviceDataSource addObject:model];
    }
}

- (UIView *)headerImageView{
    UIImage *img = [UIImage imageNamed:@"header"];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, img.size.height)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bgView.frame), CGRectGetHeight(bgView.frame))];
    [imageView setImage:img];
    [bgView addSubview:imageView];
    _headerView = bgView;
    return _headerView;
}

- (UIView *)middelDescTxtView{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5 + 5 + 89, SCREEN_WIDTH - 10, 120)];
    [label setFont:[UIFont systemFontOfSize:12.f]];
    [label setTextColor:RGB(92, 92, 92, 1)];
    [label setNumberOfLines:0];
    [label setText:@"       南海区总工会是南海区工会组织的领导机关。1955年2月24日至26日，南海县首届工会代表大会召开，正式成立了南海县总工会（时称南海县工会联合会）。1992年9月，南海撤县设市，更名为南海市总工会，2003年1月撤市设区，更名为佛山市南海区总工会。区总工会现内设机构“一室两科”：办公室、组织科、权益保障科。\n----目前，南海区总工会属下镇（街道）总工会8个，基层工会总数13982个，工会会员达60.86万人。"];
    _middelView = label;
    return _middelView;
}

- (UIView *)operationViewWithClick:(void (^)(StaffIconModel *, NSInteger))clickBlock{
    
    StaffIconModel *tx = _opDataSource[0];
    UIImage *imagesss = [UIImage imageNamed:tx.icon];
    CGFloat totalHeight = 10 + imagesss.size.height + 10 + 21 + 10;
    
    _opView = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.frame.size.height + _headerView.frame.origin.y + 5 , SCREEN_WIDTH, totalHeight)];
    [_opView setBackgroundColor:TableViewBgColor];
    self.opBlk = clickBlock;
    
    CGFloat wh = SCREEN_WIDTH / 3;

    for (int i = 0; i < _opDataSource.count ; i++) {
        StaffIconModel *model = _opDataSource[i];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(wh * i, 0, wh, _opView.bounds.size.height)];
        [view setBackgroundColor:RGB(242, 242, 242, 1)];
        
        UIImage *image = [UIImage imageNamed:model.icon];
        UIImageView *img = [[UIImageView alloc] initWithImage:image];
        [img setFrame:CGRectMake((CGRectGetWidth(view.frame) - image.size.width)/2, 10, image.size.width, image.size.height)];
        [view addSubview:img];
    
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, img.frame.size.height + img.frame.origin.y + 10, wh, 21)];
        [label setFont:[UIFont systemFontOfSize:15.f]];
        [label setText:model.title];
        [label setTextAlignment:NSTextAlignmentCenter];
        [view addSubview:label];
        if (i == 0) {
            [label setTextColor:RGB(41, 111, 230, 1)];
        }else if (i == 1){
            [label setTextColor:RGB(0, 184, 88, 1) ];
        }else{
            [label setTextColor:RGB(253, 158, 29, 1)];
        }

        [_opView addSubview:view];

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, wh, totalHeight)];
        [view addSubview:btn];
        [btn setTag:1000 + i];
        [btn addTarget:self action:@selector(operationClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
//    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
//    [line setBackgroundColor:RGB(212, 212, 212, 1)];
//    [_opView addSubview:line];
    return _opView;
}


- (UIView *)bookViewWithClick:(void (^)(StaffIconModel *,NSInteger))clickBlock{
    UIImage *image = [UIImage imageNamed:@"zgsw.png"];
    _bookView= [[UIView alloc] initWithFrame:CGRectMake(0, _opView.bounds.size.height + _opView.frame.origin.y + 5, SCREEN_WIDTH, image.size.height)];
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _bookView.frame.size.width, _bookView.bounds.size.height)];
    [imgview setImage:image];
    [_bookView addSubview:imgview];
    [imgview setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bookClick)];
    [imgview addGestureRecognizer:tap];
    
    self.bookBlk = clickBlock;
    [_bookView setBackgroundColor:[UIColor clearColor]];
    
    
//    [_bookView.layer setBorderColor:[UIColor redColor].CGColor];
//    [_bookView.layer setBorderWidth:1];
    
    return _bookView;
}

- (UIView *)serviceViewWithClick:(void (^)(StaffIconModel *, NSInteger))clickBlock{
    
    StaffIconModel *tx = _serviceDataSource[0];
    UIImage *imagesss = [UIImage imageNamed:tx.icon];
    CGFloat totalHeight = imagesss.size.height + 5 + 21 + 20;
    
    _serviceView = [[UIView alloc] initWithFrame:CGRectMake(0, _bookView.frame.origin.y + _bookView.frame.size.height + 5, SCREEN_WIDTH, totalHeight * 3)];
    self.ssBlk = clickBlock;
    
    CGFloat wh = SCREEN_WIDTH / 4;
    int collom = 0;
    int index = 0;
    int i = 0;
    CGFloat iconHeight = totalHeight;
    while (index < _serviceDataSource.count) {
        
        StaffIconModel *model = _serviceDataSource[index];
        
        CGFloat detal = (collom > 0 ? (SCREEN_HEIGHT > IPhone6_Height ? 20 : 10) : 0);
        if (collom == 2) {
            detal=detal + (SCREEN_HEIGHT > IPhone6_Height ? 20 : 10);
        }
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(wh * i, collom * 72 + detal, wh, iconHeight)];
        
        UIImage *image = [UIImage imageNamed:model.icon];
        UIImageView *img = [[UIImageView alloc] initWithImage:image];
        [img setFrame:CGRectMake((CGRectGetWidth(view.frame) - image.size.width)/2, 10, image.size.width, image.size.height)];
        [view addSubview:img];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, img.frame.size.height + img.frame.origin.y + 5, wh, 21)];
        [label setFont:[UIFont systemFontOfSize:12.f]];
        [label setText:model.title];
        [label setTextAlignment:NSTextAlignmentCenter];
        [view addSubview:label];
        
        [_serviceView addSubview:view];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, wh, iconHeight)];
        [view addSubview:btn];
        [btn setTag:2000 + index];
        [btn addTarget:self action:@selector(serviceClick:) forControlEvents:UIControlEventTouchUpInside];
        
        i++;
        index++;
        if (i == 4) {
            i = 0;
            collom++;
        }
    }
    
//    [_serviceView.layer setBorderColor:[UIColor redColor].CGColor];
//    [_serviceView.layer setBorderWidth:1];
    
    return _serviceView;
}

#pragma mark -- click methods
- (void)operationClick:(UIButton *)btn{
    NSInteger index = btn.tag - 1000;
    if (_opBlk) {
        _opBlk(_opDataSource[index],index);
    }
}

- (void)serviceClick:(UIButton *)btn{
    NSInteger index = btn.tag - 2000;
    if (_ssBlk) {
        _ssBlk(_serviceDataSource[index],index);
    }
}

- (void)bookClick{
    if (_bookBlk) {
        StaffIconModel *model = [[StaffIconModel alloc] init];
        [model setUrl:@"http://weikan.magook.com/?org=fsnhzgh-wk"];
        [model setTitle:@"南海工会电子职工书屋"];
        [model setTargetController:@"WebDetailOnlyByLinkViewController"];
        _bookBlk(model,0);
    }
}
@end
