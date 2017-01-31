//
//  ViewController.m
//  ComposeGif
//
//  Created by zhuzhilong on 17/1/30.
//  Copyright © 2017年 zhuzhilong. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface ViewController ()
@property(nonatomic,strong)NSMutableArray *images;
@end

@implementation ViewController
@synthesize images;
//1 获取我们的数据
//2 创建gif文件
//3 配置gif属性
//4 单帧添加到gif
- (void)viewDidLoad {
    [super viewDidLoad];
    [self crateGif];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)crateGif{
   //1 获取数据
    self.images= [[NSMutableArray alloc]init];
    
    for (int i=0; i<=16; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%d.jpg",i];
        [images addObject:[UIImage imageNamed:imageName]];
    }
    //2 创建gif文件
    NSArray *document = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documenStr = [document objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *textDic= [documenStr  stringByAppendingString:@"/gif"];
    [fileManager createDirectoryAtPath:textDic withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *path = [textDic stringByAppendingString:@"test1.gif"];
    NSLog(@"path = %@",path);
    //3配置gif属性
    CGImageDestinationRef destion;
    CFURLRef url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)path, kCFURLPOSIXPathStyle, false);
    destion = CGImageDestinationCreateWithURL(url, kUTTypeGIF, images.count, NULL);
    NSDictionary *frameDic = [NSDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0.3],(NSString *)kCGImagePropertyGIFDelayTime, nil] forKey:(NSString *)kCGImagePropertyGIFDelayTime];
    NSMutableDictionary *gifParmdict = [NSMutableDictionary dictionaryWithCapacity:2];
    [gifParmdict setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCGImagePropertyGIFHasGlobalColorMap];
    [gifParmdict setObject:(NSString *)kCGImagePropertyColorModelRGB forKey:(NSString *)kCGImagePropertyColorModel];
    [gifParmdict setObject:[NSNumber numberWithInt:8] forKey:(NSString *)kCGImagePropertyDepth];
    [gifParmdict setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
    NSDictionary *gifProperty = [NSDictionary dictionaryWithObject:gifParmdict forKey:(NSString *)kCGImagePropertyGIFDictionary];

    //单帧添加到gif
    for (UIImage *dimage in images) {
        
        CGImageDestinationAddImage(destion, dimage.CGImage,(__bridge  CFDictionaryRef)frameDic);
    }
    CGImageDestinationSetProperties(destion, (__bridge  CFDictionaryRef)gifProperty);
    CGImageDestinationFinalize(destion);
    CFRelease(destion);
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
