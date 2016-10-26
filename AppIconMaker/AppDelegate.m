//
//  AppDelegate.m
//  AppIconMaker
//
//  Created by wide on 10/26/16.
//  Copyright © 2016 wwideapp. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (weak) IBOutlet NSTextField *fileLabel;
@property (strong) NSURL *fileURL;
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)chooseIconFilePressed:(NSButton *)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseDirectories = NO;
    panel.canChooseFiles = YES;
    panel.allowsMultipleSelection = NO;
    
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (result) {
            _fileURL = panel.URLs.firstObject;
            _fileLabel.stringValue =  _fileURL.path;
        }
    }];
}

- (IBAction)generateButtonPressed:(NSButton *)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseDirectories = YES;
    panel.canChooseFiles = NO;
    panel.allowsMultipleSelection = NO;
    
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (result) {
            NSURL *floderURL = panel.URLs.firstObject;
            
            NSImage *image = [[NSImage alloc] initWithContentsOfURL:_fileURL];
            NSArray *array = @[@(40), @(58), @(60) ,@(80), @(87), @(120), @(180), @(1024)];
            for(NSNumber *num in array)
            {
                NSSize size = NSMakeSize(num.floatValue, num.floatValue);
                NSImage *result = [self imageResize:image newSize:size];
                
                NSString *filePath = [floderURL.path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", num]];
                [self saveImage:result atPath:filePath];
            }
        }
    }];
}

- (NSImage *)imageResize:(NSImage*)anImage newSize:(NSSize)newSize {
    NSImage *sourceImage = anImage;
    // Report an error if the source isn't a valid image
    if (![sourceImage isValid]){
        NSLog(@"Invalid Image");
    } else {
        NSImage *smallImage = [[NSImage alloc] initWithSize: newSize];
        [smallImage lockFocus];
        [sourceImage setSize: newSize];
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
        [sourceImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, newSize.width, newSize.height) operation:NSCompositeCopy fraction:1.0];
        [smallImage unlockFocus];
        return smallImage;
    }
    return nil;
}

- (void)saveImage:(NSImage *)image atPath:(NSString *)path {
    CGImageRef cgRef = [image CGImageForProposedRect:NULL
                                             context:nil
                                               hints:nil];
    NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
    [newRep setSize:[image size]];   // if you want the same resolution
    NSDictionary *imageProperty = @{NSImageInterlaced: @YES};
    NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:imageProperty];
    if (pngData) {
        [pngData writeToFile:path atomically:YES];
    }
}

@end
