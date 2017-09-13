
## 跑道视图



## 简化属性字符串

在使用属性字符串的时候，不需要写大段的样板代码，简化使用方法

### 普通

根据需要一个一个的添加需要的字符串以及对应的属性

```objective-c
// black 16
+ (instancetype) builder;
// { NS...AttributeName : (id)value}
+ (instancetype) builderWithDefaultStyle:(NSDictionary *)defaultStyle;

- (HLLAttributedBuilder *) appendString:(NSString *)string;
- (HLLAttributedBuilder *(^)(NSString *str)) appendString;

- (HLLAttributedBuilder *) appendString:(NSString *)string forStyle:(NSDictionary *)style;
- (HLLAttributedBuilder *(^)(NSString *str ,NSDictionary *style)) appendStringAndStyle;
```

例子：

```objective-c
attString = [[[[[HLLAttributedBuilder builder]
                    appendString:@"nihao"]
                   appendString:@"world" forStyle:@{NSForegroundColorAttributeName:[UIColor greenColor],
                                                    NSUnderlineColorAttributeName:[UIColor orangeColor],
                                                    NSUnderlineStyleAttributeName:@1}]
                  appendString:@"123456" forStyle:@{NSStrokeColorAttributeName:[UIColor redColor],
                                                    NSStrokeWidthAttributeName:@1}]
                 attributedString];
```

<p align="center">
  <img src="img/normal.png">
</p>

![](img/normal.png)

### 支持 NSTextAttachment

属性字符串中除了常规的字符串还可以添加图片，添加图片使用的是NSTextAttachment类，可以结合上面的普通字符串使用。

```
- (HLLAttributedBuilder *) appendAttachment:(NSTextAttachment *)attachment;
- (HLLAttributedBuilder *(^)(NSTextAttachment *))appendAttachment;
```
例子：

```objective-c
NSTextAttachment * attachment = [[NSTextAttachment alloc] init];
attachment.image = [UIImage imageNamed:@"red_dot"];
attachment.bounds = CGRectMake(0, 0, 9, 9);

 attString = [[[[[[[HLLAttributedBuilder builder]
                      appendAttachment:attachment]
                     appendString:@"nihao"]
                    appendString:@"world" forStyle:@{NSForegroundColorAttributeName:[UIColor greenColor],
                                                     NSUnderlineColorAttributeName:[UIColor orangeColor],
                                                     NSUnderlineStyleAttributeName:@1}]
                   appendString:@"123456" forStyle:@{NSStrokeColorAttributeName:[UIColor redColor],
                                                     NSStrokeWidthAttributeName:@1}]
                  appendAttachment:attachment]
                 attributedString];
```

![](img/attachment.png)

### 支持查找设置

一种情形是，已有一个字符串，需要对其中的某一些字符串进行属性字符串设置，支持精确匹配以及正则表达式匹配，并且可以结合上面的`-append..`方法一起使用。

```objective-c
+ (instancetype) builderWithString:(NSString *)originalString;
+ (instancetype) builderWithString:(NSString *)originalString defaultStyle:(NSDictionary *)defaultStyle;

- (HLLAttributedBuilder *) configString:(NSString *)string forStyle:(NSDictionary *)style;
- (HLLAttributedBuilder *(^)(NSString *str ,NSDictionary *style)) configStringAndStyle;
```

例子：

```objective-c
NSString * display = @"hello = nihao = Hello = 你好 = nihao";
    attString = [[[[[[[HLLAttributedBuilder builderWithString:display]
                      configString:@"hello" forStyle:@{NSUnderlineColorAttributeName:[UIColor redColor],
                                                       NSUnderlineStyleAttributeName:@1,
                                                       NSForegroundColorAttributeName:[UIColor orangeColor]}]
                     configString:@"nihao" forStyle:@{NSStrokeColorAttributeName:[UIColor redColor],
                                                      NSStrokeWidthAttributeName:@1}]
                    configString:@"H" forStyle:@{NSBackgroundColorAttributeName:[UIColor greenColor]}]
                   appendAttachment:attachment]
                  appendString:@"娃大喜"]
                 attributedString];
```

![](img/config.png)













