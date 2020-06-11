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
#import <Cocoa/Cocoa.h>
@interface AppController : NSObject {
    NSDictionary *attribs;
	IBOutlet NSTextField	*name;
	IBOutlet NSTextField	*package;
	IBOutlet NSTextField	*version;
	IBOutlet NSTextField	*size;
	IBOutlet NSTextField	*website;
	IBOutlet NSTextField	*icon;
	IBOutlet NSTextField	*maintainer;
	IBOutlet NSTextField	*depends;
	IBOutlet NSTextField	*conflicts;
	IBOutlet NSTextField	*description;
	IBOutlet NSComboBox		*section;
	IBOutlet NSTextField	*files;
	IBOutlet NSButton		*browse;
	IBOutlet NSButton		*build;
	IBOutlet NSButton		*preinst;		
	IBOutlet NSButton		*postinst;			
	IBOutlet NSButton		*prerm; 
	IBOutlet NSButton		*postrm;
	IBOutlet NSTextView		*preinstbox;	
	IBOutlet NSScrollView	*preinstboxView;
	IBOutlet NSTextView		*postinstbox;	
	IBOutlet NSScrollView	*postinstboxView;
	IBOutlet NSTextView		*prermbox;		
	IBOutlet NSScrollView	*prermboxView;
	IBOutlet NSTextView		*postrmbox;		
	IBOutlet NSScrollView	*postrmboxView;
	IBOutlet NSWindow		*window;
}
- (IBAction) browse:(id)sender;
- (IBAction) clearText:(id)sender;
- (IBAction) saveText:(id)sender;
- (IBAction) build:(id)sender;

@end
