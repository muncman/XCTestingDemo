#import "tuneup_js/tuneup.js"
#import "uiautomationHelpers.js"

UIALogger.logMessage('==== Starting Tests ====');

//
// Specs
//

test('first tab screen', function(target, app) {
 var window = app.mainWindow();
 assertTrue(staticTextsContain(window.staticTexts(), 
 	'First View'), 'Should have this top label.');
});

UIALogger.logMessage('==== Tests Completed ====');
