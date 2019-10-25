//
//  UIImage+category.m
//  iLearning
//
//  Created by Sidney on 13-8-20.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "UIImage+category.h"
#import <Accelerate/Accelerate.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@implementation UIImage (category)


- (UIImage *)imageWithGrayScaleImage:(UIImage *)inputImg
{
    //Creating image rectangle
    //CGRect imageRect = CGRectMake(0, 0, inputImg.size.width / (CGFloat)[inputImg scale], inputImg.size.height / (CGFloat)[inputImg scale]);
    CGRect imageRect = CGRectMake(0, 0, inputImg.size.width, inputImg.size.height);
    
    //Allocating memory for pixels
    int width = imageRect.size.width;
    int height = imageRect.size.height;
    
    uint32_t *pixels = (uint32_t*)malloc(width * height * sizeof(uint32_t));
    
    //Clearing the memory to preserve any transparency.(Alpha)
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    //Creating a context with RGBA pixels
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    //Drawing the bitmap to the context which will fill the pixels memory
    CGContextDrawImage(context, imageRect, [inputImg CGImage]);
    
    //Indices as ARGB or RGBA
    const int RED = 1;
    const int GREEN = 2;
    const int BLUE = 3;
    
    for (int y = 0; y < height; y++)
    {
        for (int x = 0; x < width; x++)
        {
            uint8_t* rgbaPixel = (uint8_t*)&pixels[y * width + x];
            
            //Calculating the grayScale value
            uint32_t grayPixel = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
            //Setting the pixel to gray
            rgbaPixel[RED] = grayPixel;
            rgbaPixel[GREEN] = grayPixel;
            rgbaPixel[BLUE] = grayPixel;
        }
    }
    
    //Creating new CGImage from the context with modified pixels
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    
    //Releasing resources to free up memory
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    //Creating UIImage for return value
    //UIImage* newUIImage = [UIImage imageWithCGImage:newCGImage scale:(CGFloat)[inputImg scale] orientation:UIImageOrientationUp];
    UIImage* newUIImage = [UIImage imageWithCGImage:newCGImage];
    
    //Releasing the CGImage
    CGImageRelease(newCGImage);
    
    return newUIImage;
}

+ (UIImage *)createImageWithBgColor:(UIColor *)color size:(CGSize)size cornerRadius:(float)corner
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width * 2, size.height * 2)];
    view.backgroundColor = color;
    [view.layer setCornerRadius:corner];
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = newSize.width;
    CGFloat targetHeight = newSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, newSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(newSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)gaussBlur:(CGFloat)blur
{
    NSData *imageData = UIImageJPEGRepresentation(self, 1); // convert to jpeg
    UIImage* destImage = [UIImage imageWithData:imageData];
    
    
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = destImage.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    
    //create vImage_Buffer with data from CGImageRef
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}

+ (void)saveImageToAlbum:(UIImage *)image
{
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 5) {
        ALAssetsLibrary* library = [ALAssetsLibrary new];
        [library saveImage:image toAlbum:BUNDLE_DISPLAY_NAME withCompletionBlock:^(NSError *error) {
            if (error) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"保存相册失败"
                                                               message:@"可以去 隐私-照片 设置"
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil, nil];
                [alert show];
                // UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
            }
        }];
    }else{
        UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //    [self showToastWithMessage:[error localizedDescription] showTime:1];
}



@end
