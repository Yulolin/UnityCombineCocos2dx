/****************************************************************************
 Copyright (c) 2017-2018 Xiamen Yaji Software Co., Ltd.
 
 http://www.cocos2d-x.org
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#include "HelloWorldScene.h"
#include "SimpleAudioEngine.h"
#include <iostream>
#include "ui/CocosGUI.h"

USING_NS_CC;

Scene* HelloWorld::createScene()
{
    return HelloWorld::create();
}

// Print useful error message instead of segfaulting when files are not there.
static void problemLoading(const char* filename)
{
    printf("Error while loading: %s\n", filename);
    printf("Depending on how you compiled you might have to add 'Resources/' in front of filenames in HelloWorldScene.cpp\n");
}

void HelloWorld::drawButton(){
    auto visibleSize = Director::getInstance()->getVisibleSize();
    Vec2 origin     = Director::getInstance()->getVisibleOrigin();

    // 1. 创建一个 Layout，作为按钮“底板”
    auto colorBtn = ui::Layout::create();
    colorBtn->setContentSize(Size(visibleSize.width/2, 60));  // 按钮大小
    colorBtn->setBackGroundColorType(ui::Layout::BackGroundColorType::SOLID);
    colorBtn->setBackGroundColor(Color3B::BLUE);
    colorBtn->setBackGroundColorOpacity(128);
    // 居中放到底部
    colorBtn->setPosition(origin + Vec2(
        0,
        (colorBtn->getContentSize().height) * 0.5f + 10
    ));

    // 2. 启用触摸
    colorBtn->setTouchEnabled(true);
    colorBtn->addClickEventListener([=](Ref*){
        printf("纯色按钮被点击！");
    });

    // 3. （可选）在按钮上加个文字 Label
    auto lbl = Label::createWithSystemFont("点 我", "Arial", 24);
    lbl->setPosition(colorBtn->getContentSize() * 0.5f);
    colorBtn->addChild(lbl);

    // 4. 添加到场景
    this->addChild(colorBtn);
}

void HelloWorld::drawScroolView(){
    auto visibleSize = Director::getInstance()->getVisibleSize();
    Vec2 origin = Director::getInstance()->getVisibleOrigin();
    // 2. 创建 ScrollView
    auto scrollView = cocos2d::ui::ScrollView::create();
    // 设置滚动视图大小（可见区域）
    scrollView->setContentSize(Size(80, 150));
    // 设置滚动方向：VERTICAL, HORIZONTAL, BOTH
    scrollView->setDirection(ui::ScrollView::Direction::BOTH);
    // 设置内层容器大小（内容区域大于可见区域才能滚动）
    scrollView->setInnerContainerSize(Size(150, 250));
    scrollView->setClippingEnabled(true);

    // 3. 把 ScrollView 放在屏幕正中间
    scrollView->setPosition(origin +
                            Vec2(0, (visibleSize - scrollView->getContentSize()).height * 0.5f)
    );

    //     4. 给滚动视图加个背景，便于观察
    scrollView->setBackGroundColorType(ui::Layout::BackGroundColorType::SOLID);
    scrollView->setBackGroundColor(Color3B::GRAY);
    scrollView->setBackGroundColorOpacity(160);

    // 5. 向内部容器里添加几个示例子节点
    for (int i = 0; i < 5; ++i)
    {
        // 用一个简单的彩色 Layer 代替示例内容
        auto layer = LayerColor::create(
            Color4B(80 * i, 255 - 20*i, 150 + 30*i, 255),
            40, 40
        );
        // 随意放置在内容区内
        layer->setPosition(Vec2(150 - i*35, i*40));
        scrollView->addChild(layer);
    }

    // 6. 把 ScrollView 加到场景
    this->addChild(scrollView);
}

void HelloWorld::drawOutlineAndRect(){
    auto visibleSize = Director::getInstance()->getVisibleSize();
    Vec2 origin = Director::getInstance()->getVisibleOrigin();
    
    // 1. 创建一个 DrawNode
    auto drawNode = DrawNode::create();
    this->addChild(drawNode, /* z-order */ 10);
    // 2. 定义正方形的四个顶点（假设边长 100）
    float side = 100.0f;
    Vec2 vertices[4] = {
        origin,
        origin + Vec2(side, 0),                  // 右下
        origin + Vec2(side, side),               // 右上
        origin + Vec2(0, side)                   // 左上
    };

//    // 3. 绘制实心正方形（填充色为半透明红，4 个顶点顺时针/逆时针）
//    drawNode->drawSolidPoly(vertices,
//                            4,
//                            Color4F(0.0f, 0.0f, 1.0f, 0.5f));
    
    // 3. 定义四个角点（全屏矩形）
   Vec2 verts[4] = {
       Vec2(origin.x,                    origin.y),                    // 左下
       Vec2(origin.x + visibleSize.width, origin.y),                    // 右下
       Vec2(origin.x + visibleSize.width, origin.y + visibleSize.height),// 右上
       Vec2(origin.x,                    origin.y + visibleSize.height) // 左上
   };
    // 方案一：drawSegment
    float width = 4.0f;
    for (int i = 0; i < 4; ++i) {
        drawNode->drawSegment(verts[i],
                              verts[(i + 1) % 4],
                              width * 0.5f,       // 半径
                              Color4F::GREEN);
    }
}

void HelloWorld::drawTest(){
    drawOutlineAndRect();
    drawButton();
    drawScroolView();
}

// on "init" you need to initialize your instance
bool HelloWorld::init()
{
    //////////////////////////////
    // 1. super init first
    if ( !Scene::init() )
    {
        return false;
    }

    auto visibleSize = Director::getInstance()->getVisibleSize();
    Vec2 origin = Director::getInstance()->getVisibleOrigin();

    // 获取当前线程的 std::thread::id
    std::thread::id this_id = std::this_thread::get_id();
    // 直接输出（实现会把 id 格式化成可读字符串）
    std::cout << "helloworld thread id: " << this_id << std::endl;
    
    drawTest();

    auto fullPath = FileUtils::getInstance()->fullPathForFilename("CloseNormal.png");
    log("fullPath = %s", fullPath.c_str());
    
    auto closeItem = MenuItemImage::create(
                                           "CloseNormal.png",
                                           "CloseSelected.png",
                                           CC_CALLBACK_1(HelloWorld::menuCloseCallback, this));

    if (closeItem == nullptr ||
        closeItem->getContentSize().width <= 0 ||
        closeItem->getContentSize().height <= 0)
    {
        problemLoading("'CloseNormal.png' and 'CloseSelected.png'");
    }
    else
    {
        float x = origin.x + visibleSize.width - closeItem->getContentSize().width/2;
        float y = origin.y + closeItem->getContentSize().height/2;
        closeItem->setPosition(Vec2(x,y));
    }

    // create menu, it's an autorelease object
    auto menu = Menu::create(closeItem, NULL);
    menu->setPosition(Vec2::ZERO);
    this->addChild(menu, 1);

    /////////////////////////////
    // 3. add your codes below...

    // add a label shows "Hello World"
    // create and initialize a label

    auto label = Label::createWithTTF("Hello World", "fonts/Marker Felt.ttf", 24);
    if (label == nullptr)
    {
        problemLoading("'fonts/Marker Felt.ttf'");
    }
    else
    {
        // position the label on the center of the screen
        label->setPosition(Vec2(origin.x + visibleSize.width/2,
                                origin.y + visibleSize.height - label->getContentSize().height));

        // add the label as a child to this layer
        this->addChild(label, 1);
    }

    // add "HelloWorld" splash screen"
    auto sprite = Sprite::create("HelloWorld.png");
    if (sprite == nullptr)
    {
        problemLoading("'HelloWorld.png'");
    }
    else
    {
        // position the sprite on the center of the screen
        sprite->setPosition(Vec2(visibleSize.width/2 + origin.x, visibleSize.height/2 + origin.y));

        // add the sprite as a child to this layer
        this->addChild(sprite, 0);
    }
    return true;
}


void HelloWorld::menuCloseCallback(Ref* pSender)
{
    //Close the cocos2d-x game scene and quit the application
    Director::getInstance()->end();

    /*To navigate back to native iOS screen(if present) without quitting the application  ,do not use Director::getInstance()->end() as given above,instead trigger a custom event created in RootViewController.mm as below*/

    //EventCustom customEndEvent("game_scene_close_event");
    //_eventDispatcher->dispatchEvent(&customEndEvent);


}
