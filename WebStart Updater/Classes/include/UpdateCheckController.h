/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      UpdateCheckController.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

@class DownloadController, InstallController;

/*!
 * @class       UpdateCheckController
 * @abstract    ...
 */
@interface UpdateCheckController: NSObject < NSTableViewDataSource >
{
@protected
    
    NLUISegmentedTabView * tabView;
    NSProgressIndicator  * progressBar;
    NSMutableData        * data;
    NSDictionary         * versions;
    NSDictionary         * newVersions;
    DownloadController   * downloadController;
    InstallController    * installController;
    NSPanel              * noUpdatePanel;
    NSPanel              * updatePanel;
    NSWindow             * mainWindow;
    NSMutableArray       * packages;
    NSTableView          * tableView;
    
@private
    
    id r1;
    id r2;
}

@property( nonatomic, retain ) IBOutlet NLUISegmentedTabView * tabView;
@property( nonatomic, retain ) IBOutlet NSProgressIndicator  * progressBar;
@property( nonatomic, retain ) IBOutlet DownloadController   * downloadController;
@property( nonatomic, retain ) IBOutlet InstallController    * installController;
@property( nonatomic, retain ) IBOutlet NSPanel              * noUpdatePanel;
@property( nonatomic, retain ) IBOutlet NSPanel              * updatePanel;
@property( nonatomic, retain ) IBOutlet NSWindow             * mainWindow;
@property( nonatomic, retain ) IBOutlet NSTableView          * tableView;

- ( void )sheetDidEnd: ( NSWindow * )sheet returnCode: ( int )returnCode contextInfo: ( void * )contextInfo;
- ( IBAction )cancelUpdate: ( id )sender;
- ( IBAction )quitUpdater: ( id )sender;
- ( IBAction )performUpdate: ( id )sender;

@end
