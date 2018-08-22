//
//  MM_GiftEffectView.m
//  Weather_App
//
//  Created by user1 on 2018/8/19.
//  Copyright © 2018年 Yrocky. All rights reserved.
//

#import "MM_GiftEffectView.h"
#import <SpriteKit/SpriteKit.h>

@interface MM_GiftEffectView()
@property (nonatomic ,strong) SKView * contentView;
@end

@implementation MM_GiftEffectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[SKView alloc] init];
        [self addSubview:self.contentView];
        
//        let skView = SKView.init(frame: self.view.bounds)
//        if(skView.scene == nil){
//            skView.showsFPS = true
//            skView.showsNodeCount = true
//            let scene = GameScene(size: skView.bounds.size)
//            skView.presentScene(scene)
//        }
//        self.view.addSubview(skView)
        
    }
    return self;
}

static CGFloat kViewCenterX;
static CGFloat kViewCenterY;

- (void) addOneGiftNode:(NSString *)giftName{
    
    SKSpriteNode * node = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:giftName]];
    node.size = CGSizeMake(20, 20);
    node.position = CGPointMake(kViewCenterX, kViewCenterY);
    node.anchorPoint = CGPointMake(0.5, 0.5);
    
//    let KScreenWidth = UIScreen.main.bounds.width
//    let KScreenHeight = UIScreen.main.bounds.height
//    func addNode() {
//        let texture = SKTexture.init(imageNamed: "ao.jpg")  // 纹理
//        let splash = SKSpriteNode.init(texture: texture)
//        //        let splash = SKSpriteNode.init(imageNamed: "ao.jpg")
//        splash.size = CGSize.init(width: KScreenWidth, height: KScreenHeight)
//        splash.position = CGPoint.init(x: KScreenWidth/2, y: KScreenHeight/2)
//        // 设置锚点
//        //        splash.anchorPoint = CGPoint.init(x: 0.0, y: 0.0)
//        // 精灵着色
//        splash.color = SKColor.green
//        splash.colorBlendFactor = 0.3   // 颜色混合因子0~1
//        splash.setScale(2)  // 缩放 放大两倍
//        //        splash.xScale = 2   // 单独缩放x
//        splash.zRotation = CGFloat(Double.pi)/2  // 旋转
//        splash.alpha = 0.5
//        splash.isHidden = false
//        self.addChild(splash)
//
//        //        splash.removeFromParent()
//        //        removeAllChildren()
//    }
}
@end
