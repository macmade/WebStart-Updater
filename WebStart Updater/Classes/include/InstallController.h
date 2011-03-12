/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      DownloadController.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

/*!
 * @class       DownloadController
 * @abstract    ...
 */
@interface InstallController: NSObject
{
@protected
    
    NLUISegmentedTabView * tabView;
    NSProgressIndicator  * progressBar;
    NSTextField          * title;
    NSTextField          * installPhase;
    NSTextField          * installStatus;
    NSArray              * packages;
    NLUIInstaller        * installer;
    NSButton             * installButton;
    NSDictionary         * versions;
    NSUInteger             currentPackage;
    
@private
    
    id r1;
    id r2;
}

@property( nonatomic, retain ) IBOutlet NLUISegmentedTabView * tabView;
@property( nonatomic, retain ) IBOutlet NSProgressIndicator  * progressBar;
@property( nonatomic, retain ) IBOutlet NSTextField          * title;
@property( nonatomic, retain ) IBOutlet NSTextField          * installPhase;
@property( nonatomic, retain ) IBOutlet NSTextField          * installStatus;
@property( nonatomic, retain ) IBOutlet NSButton             * installButton;
@property(            retain )          NSDictionary         * versions;
@property(            retain )          NSArray              * packages;

- ( void )install;
- ( IBAction )install: ( id )sender;

@end
