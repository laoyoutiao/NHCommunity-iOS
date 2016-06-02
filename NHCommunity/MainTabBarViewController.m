 //
//  MainTabBarViewController.m
//  NHCommunity
//
//  Created by Arsenal on 15/9/24.
//  Copyright (c) 2015年 ku. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "CommunityViewController.h"
#import "LawListViewController.h"
#import "LifeMarketController.h"
#import "ActiveViewController.h"
#import "QuestionViewController.h"
#import "BaseNavViewController.h"
#import "StaffSercieHomeViewController.h"
#import "LoveHomeViewController.h"

@interface MainTabBarViewController ()

@property (nonatomic, assign) NSInteger curSelectIndex;
@end

@implementation MainTabBarViewController

//- (instancetype)initWithIndex:(NSInteger)index{
//    self = [self initWithNibName:nil bundle:nil];
//    if (self) {
//        self.curSelectIndex = index;
//    }
//    return self;
//}
//
//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if(self){
//        self.curSelectIndex = 3;
//    }
//    return self;
//}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goMainPage) name:@"goBack" object:nil];
//    
//    self.navigationController.navigationBarHidden = YES;
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"goBack" object:nil];
//    [super viewWillDisappear:animated];
//}

- (void)goMainPage{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
  
    CommunityViewController *comm = [[CommunityViewController alloc] initWithNibName:@"CommunityViewController" bundle:nil];
    BaseNavViewController *nav1 = [[BaseNavViewController alloc] initWithRootViewController:comm];
    [self setupChildViewController:nav1 title:@"知工会" imageName:@"01_normal.png" selectedImageName:@"01.png"];


    LawListViewController *law = [[LawListViewController alloc] initWithNibName:@"LawListViewController" bundle:nil lawType:0];
    BaseNavViewController *nav2 = [[BaseNavViewController alloc] initWithRootViewController:law];
    [self setupChildViewController:nav2 title:@"护权益" imageName:@"02_normal.png" selectedImageName:@"02.png"];
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([LifeMarketController class]) bundle:nil];
//    UIViewController *vc = [storyboard instantiateInitialViewController];
//    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self setupChildViewController:nav3 title:@"服务超市" imageName:@"03_normal" selectedImageName:@"03"];
    
    LoveHomeViewController *love = [[LoveHomeViewController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:love];
    [self setupChildViewController:nav3 title:@"职工·家" imageName:@"zgj.png" selectedImageName:@"zgj-1.png"];
    
    
//    ActiveViewController *active = [[ActiveViewController alloc] initWithNibName:@"ActiveViewController" bundle:nil];
//    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:active];
//      [self setupChildViewController:nav4 title:@"活动中心" imageName:@"04_normal" selectedImageName:@"04"];
    

//      QuestionViewController *q = [[QuestionViewController alloc] initWithNibName:@"QuestionViewController" bundle:nil title:@"综合咨询"];
//     UINavigationController *nav5 = [[UINavigationController alloc] initWithRootViewController:q];
//     [self setupChildViewController:nav5 title:@"综合资讯" imageName:@"05_normal" selectedImageName:@"05"];
    
    StaffSercieHomeViewController *home = [[StaffSercieHomeViewController alloc] init];
    UINavigationController *nav5 = [[UINavigationController alloc] initWithRootViewController:home];
    [self setupChildViewController:nav5 title:@"惠服务" imageName:@"wdfw.png" selectedImageName:@"wdfw-1.png"];

    
    self.viewControllers = @[nav1,nav2,nav3,nav5];
    NSInteger index = [[[NSUserDefaults standardUserDefaults] objectForKey:@"index"] integerValue];
    self.selectedIndex = index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupChildViewController:(UIViewController *)childVc
                           title:(NSString *)title
                       imageName:(NSString *)imageName
               selectedImageName:(NSString *)selectedImageName
{
    // 设置控制器属性
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.title = title;
    
//    // 包装一个导航控制器
//    if ([childVc isKindOfClass:[CTopMyCenterViewController class]]) {
//        //        [self addChildViewController:childVc];
//        CTopNavigationController *nav = [[CTopNavigationController alloc] initWithRootViewController:childVc];
//        [self addChildViewController:nav];
//    }else {
//        CTopNavigationController *nav = [[CTopNavigationController alloc] initWithRootViewController:childVc];
//        [self addChildViewController:nav];
//    }
    
    // 添加tabbar内部按钮
//    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
