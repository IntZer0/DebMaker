/*
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "AppController.h"
@implementation AppController
- (void)awakeFromNib {
    attribs = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSNumber alloc] initWithInt:0755], NSFilePosixPermissions, nil];
}
- (IBAction) browse:(id)sender {
    NSOpenPanel *op = [NSOpenPanel openPanel];
    int iResult;
    [op setCanChooseDirectories : YES ];
    [op setCanChooseFiles : NO ];
    NSArray* fileTypes = @[];
    [op setAllowedFileTypes:fileTypes];
    iResult = [op runModal];
    if (iResult == NSModalResponseOK){
        for( NSURL* URL in [op URLs] )
        {
            NSLog( @"%@", [URL path] );
            [files setStringValue: [URL path]];
        }
    }
    
    [[NSFileManager defaultManager] removeItemAtPath:[[NSString alloc] initWithFormat:@"%@/DEBIAN", [files stringValue]] error:NULL];
    [[NSFileManager defaultManager] createDirectoryAtPath:[[NSString alloc] initWithFormat:@"%@/DEBIAN", [files stringValue]] withIntermediateDirectories:false attributes:attribs error:nil];
}
- (IBAction) clearText:(id)sender {
    switch ([sender tag]) {
        case 1: [preinstbox setString:@"#!/bin/bash\n"]; break;
        case 2: [postinstbox setString:@"#!/bin/bash\n"]; break;
        case 3: [prermbox setString:@"#!/bin/bash\n"]; break;
        case 4: [postrmbox setString:@"#!/bin/bash\n"]; break;
    }
}
- (IBAction) saveText:(id)sender {
    [[NSFileManager defaultManager] createDirectoryAtPath:[[NSString alloc] initWithFormat:@"%@/DEBIAN", [files stringValue]] withIntermediateDirectories:false attributes:attribs error:nil];
    NSString *saveFile;
    NSString *file;
    switch ([sender tag]) {
        case 1: saveFile = [[NSString alloc] initWithString:[preinstbox string]]; file = [[NSString alloc] initWithFormat:@"%@/DEBIAN/preinst", [files stringValue]]; break;
        case 2: saveFile = [[NSString alloc] initWithString:[postinstbox string]]; file = [[NSString alloc] initWithFormat:@"%@/DEBIAN/postinst", [files stringValue]]; break;
        case 3: saveFile = [[NSString alloc] initWithString:[prermbox string]]; file = [[NSString alloc] initWithFormat:@"%@/DEBIAN/prerm", [files stringValue]]; break;
        case 4: saveFile = [[NSString alloc] initWithString:[postrmbox string]]; file = [[NSString alloc] initWithFormat:@"%@/DEBIAN/postrm", [files stringValue]]; break;
    } [saveFile writeToFile:file atomically:NO encoding:NSUTF8StringEncoding error:NULL]; [[NSFileManager defaultManager] setAttributes:attribs ofItemAtPath:file error:NULL];
}
- (IBAction) build:(id)sender {
    NSString *control = [[NSString alloc] initWithString:@"Architecture: iphoneos-arm\n"];
    NSString *nameString = [[NSString alloc] initWithFormat:@"Name: %@\n", [name stringValue]]; if (![[name stringValue] isEqualToString:@""]) control = [control stringByAppendingString:nameString];
    NSString *packageString = [[NSString alloc] initWithFormat:@"Package: %@\n", [package stringValue]]; if (![[package stringValue] isEqualToString:@""]) control = [control stringByAppendingString:packageString];
    NSString *versionString = [[NSString alloc] initWithFormat:@"Version: %@\n", [version stringValue]]; if (![[version stringValue] isEqualToString:@""]) control = [control stringByAppendingString:versionString];
    NSString *sizeString = [[NSString alloc] initWithFormat:@"Size: %@\n", [size stringValue]]; if (![[size stringValue] isEqualToString:@""]) control = [control stringByAppendingString:sizeString];
    NSString *websiteString = [[NSString alloc] initWithFormat:@"Website: %@\n", [website stringValue]]; if (![[website stringValue] isEqualToString:@""]) control = [control stringByAppendingString:websiteString];
    NSString *iconString = [[NSString alloc] initWithFormat:@"Icon: %@\n", [icon stringValue]]; if (![[icon stringValue] isEqualToString:@""]) control = [control stringByAppendingString:iconString];
    NSString *maintainerString = [[NSString alloc] initWithFormat:@"Maintainer: %@\n", [maintainer stringValue]]; if (![[maintainer stringValue] isEqualToString:@""]) control = [control stringByAppendingString:maintainerString];
    NSString *dependsString = [[NSString alloc] initWithFormat:@"Depends: %@\n", [depends stringValue]]; if (![[depends stringValue] isEqualToString:@""]) control = [control stringByAppendingString:dependsString];
    NSString *conflictsString = [[NSString alloc] initWithFormat:@"Conflicts: %@\n", [conflicts stringValue]]; if (![[conflicts stringValue] isEqualToString:@""]) control = [control stringByAppendingString:conflictsString];
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"Description: %@\n", [description stringValue]]; if (![[description stringValue] isEqualToString:@""]) control = [control stringByAppendingString:descriptionString];
    NSString *sectionString = [[NSString alloc] initWithFormat:@"Section: %@\n", [section stringValue]]; if (![[section stringValue] isEqualToString:@""]) control = [control stringByAppendingString:sectionString];
    [control writeToFile:[[NSString alloc] initWithFormat:@"%@/DEBIAN/control", [files stringValue]] atomically: NO encoding:NSUTF8StringEncoding error:NULL];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *directoryURL = [NSURL URLWithString:[files stringValue]];
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    
    NSDirectoryEnumerator *enumerator = [fileManager
                                         enumeratorAtURL:directoryURL
                                         includingPropertiesForKeys:keys
                                         options:0
                                         errorHandler:^BOOL(NSURL *url, NSError *error) {
        return YES;
    }];
    
    for (NSURL *url in enumerator) {
        NSError *error;
        NSNumber *isDirectory = nil;
        if (! [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
            // handle error
        }
        else if (![isDirectory boolValue]) {
            if ([[NSString stringWithFormat:@"%@",url] hasSuffix:@".DS_Store"]) {
                [fileManager removeItemAtURL:url error:nil];
            }
        }
    }
    
    NSTask *task = [[[NSTask alloc] init] autorelease];
    [task setArguments:[NSArray arrayWithObjects:@"-Zgzip", @"-b", [files stringValue], nil]];
    [task setLaunchPath:[[NSBundle mainBundle] pathForResource:@"dpkg-deb" ofType:nil]];
    [task launch];
}
@end
