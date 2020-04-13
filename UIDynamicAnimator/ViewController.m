//
//  ViewController.m
//  UIDynamicAnimator
//
//  Created by guoyf on 2020/4/13.
//  Copyright © 2020 guoyf. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UICollisionBehaviorDelegate>

/**
 *  仿真器，也是仿真行为的执行者
 */
@property (nonatomic, strong) UIDynamicAnimator *animator;

/**
 *  重力行为
 */
@property (nonatomic, strong) UIGravityBehavior *gravity;

/**
 *  碰撞行为
 */
@property (nonatomic, strong) UICollisionBehavior *collision;


/**
 *  依附行为
 */
@property (nonatomic, strong) UIAttachmentBehavior *attachment;

/**
 *  吸附行为
 */
@property (nonatomic, strong) UISnapBehavior *snap;

/**
 *  推动行为
 */
@property (nonatomic, strong) UIPushBehavior *push;

@property (nonatomic,strong) UIView *preView;


@end

@implementation ViewController

/**
 *  仿真器，也是仿真行为的执行者
 */
- (UIDynamicAnimator *)animator
{
    if (!_animator)
    {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    
    return _animator;
}

/**
 *  重力行为
 */
- (UIGravityBehavior *)gravity
{
    if (!_gravity)
    {
        _gravity = [[UIGravityBehavior alloc] init];
        
        /*
         修改方向的方式有多种
         1.使用二维向量 gravityDirection =  CGVectorMake(1, 1) 控制方向
         2.设置角度  angle =  M_PI_2/3; 弧度
         3.设置角度和重力加速度  [_gravity setAngle:M_PI magnitude:0.8]
         */
//        _gravity.gravityDirection = CGVectorMake(1, 1);// 方向 和 速度大小 的 矢量

//        _gravity.angle = M_PI_2/3;// 方向 弧度
//         _gravity.magnitude = 1.;// 重力加速度（速度大小）1000 point/s2  举例：y=gt2

        [_gravity setAngle:M_PI/3.0 magnitude:0.2];// 动态修改
    }
    
    return _gravity;
}

/**
 *  碰撞行为
 */
- (UICollisionBehavior *)collision
{
    if (!_collision)
    {
        _collision = [[UICollisionBehavior alloc] init];
        //不会超过边界
        _collision.translatesReferenceBoundsIntoBoundary = YES;
        /*
         设置碰撞类型
         UICollisionBehaviorModeItems  元素之间的碰撞, 设置translatesReferenceBoundsIntoBoundary属性也没用，只在元素间发生碰撞
         UICollisionBehaviorModeBoundaries   边界碰撞，需要配合UICollisionBehaviorModeBoundaries为YES才能发生边界碰撞
         UICollisionBehaviorModeEverything   碰撞所有
         */
        _collision.collisionMode = UICollisionBehaviorModeEverything;
        _collision.collisionDelegate = self;
        
        //设置碰撞边界
        // 1 bezierPath 边界
        UIBezierPath *bezierPath1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)) radius:CGRectGetWidth(self.view.bounds)/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
        [_collision addBoundaryWithIdentifier:@"bezierPath1" forPath:bezierPath1];
        
        // 2 point1 - point2 边界
//        [_collision addBoundaryWithIdentifier:@"point1_point2" fromPoint:CGPointMake(0, 300) toPoint:CGPointMake(CGRectGetWidth(self.view.bounds), 400)];
            

        // 注意 获取 和 remove
//            NSArray *boundarys = self.collision.boundaryIdentifiers;
//            [self.collision removeAllBoundaries];
    }
    
    return _collision;
}

- (UIAttachmentBehavior *)attachmentView1:(UIView *)view1 view2:(UIView *)view2{
        // 1 可以item 与 item
            UIAttachmentBehavior * attachment = [[UIAttachmentBehavior alloc] initWithItem:view1 attachedToItem:view2];
            attachment.length = 100;// 距离
            attachment.damping = 0.3;// 阻尼系数（阻碍变化）
            attachment.frequency = 0.5;// 振动频率，（变化速度）
            return attachment;
        //    self.attach.anchorPoint = CGPointMake(100, 100);
    
//    // 2 可以跟锚点
//    if (!_attachment) {
//        _attachment = [[UIAttachmentBehavior alloc] init];
//        _attachment.length = 100;// 距离
//        _attachment.damping = 0.3;// 阻尼系数（阻碍变化）
//        _attachment.frequency = 0.5;// 振动频率，（变化速度）
//        _attachment.anchorPoint = CGPointMake(100, 100);
//    }
//
//    return _attachment;
}

- (UISnapBehavior *)snapForView:(UIView *)view{
    UISnapBehavior * snap = [[UISnapBehavior alloc] initWithItem:view snapToPoint:CGPointMake(200, 200)];
    snap.damping = 0.3;//振动频率
    return snap;
}

- (UIPushBehavior *)push{
    if (!_push) {
        _push = [[UIPushBehavior alloc] init];
        _push.active = YES; //是否激活
        _push.angle = M_PI_4; // 方向
        _push.magnitude = 0.5; // 力
    }
    return _push;
}

/**
 *  创建一个视图
 *
 *  @param frame           frame description
 *  @param backgroundColor backgroundColor description
 *
 *  @return return value description
 */
- (UIView *)createViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor
{
    UIView *v = [[UIView alloc] initWithFrame:frame];
    v.backgroundColor = backgroundColor;
    [self.view addSubview:v];
    return v;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createItem) userInfo:nil repeats:YES];
    
}

- (void)createItem
{
    int width = 40;
    
    //视图
    UIView *view = [self createViewWithFrame:CGRectMake(arc4random_uniform(330), 0, width, width) backgroundColor:[UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]];
    view.layer.cornerRadius = width/2;
    
    // 设置动态行为参数
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[view]];
    // 设置弹性
    [itemBehavior setElasticity:1.0];
    
    //添加仿真元素 添加item
    [self.gravity addItem:view];
    [self.collision addItem:view];
    
    //执行重力行为
    [self.animator addBehavior:self.gravity];
    [self.animator addBehavior:self.collision];
    
    //添加依附行为
//    if (self.preView) {
//        UIAttachmentBehavior * attach = [self attachmentView1:self.preView view2:view];
//        [self.animator addBehavior:attach];
//
//    }
//    self.preView = view;
    
    //添加吸附行为
//    UISnapBehavior * snap = [self snapForView:view];
//    [self.animator addBehavior:snap];
//
    
    [self.animator addBehavior:self.push];
    [self.animator addBehavior:itemBehavior];
}


- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator {
    NSLog(@"==================");
}
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    NSLog(@"==================");
}

@end
