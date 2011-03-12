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

@class InstallController;

/*!
 * @class       DownloadController
 * @abstract    ...
 */
@interface DownloadController: NSObject
{
@protected
    
    NLUISegmentedTabView * tabView;
    NSProgressIndicator  * progressBar;
    NSTextField          * title;
    NSTextField          * statusText;
    NSTextField          * speedText;
    NSTextField          * timeRemainingText;
    NSArray              * packages;
    NLUIURLDownloader    * downloader;
    NSUInteger             currentURL;
    InstallController    * installController;
    
@private
    
    id r1;
    id r2;
}

@property( nonatomic, retain ) IBOutlet NLUISegmentedTabView * tabView;
@property( nonatomic, retain ) IBOutlet NSProgressIndicator  * progressBar;
@property( nonatomic, retain ) IBOutlet NSTextField          * title;
@property( nonatomic, retain ) IBOutlet NSTextField          * statusText;
@property( nonatomic, retain ) IBOutlet NSTextField          * speedText;
@property( nonatomic, retain ) IBOutlet NSTextField          * timeRemainingText;
@property( nonatomic, retain ) IBOutlet InstallController    * installController;
@property(            retain )          NSArray              * packages;

- ( void )download;

@end
