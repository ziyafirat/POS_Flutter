# Terminal Closed Screen Implementation

## Overview

A new "Terminal Closed" screen has been implemented that automatically displays when the WebAPI substate indicates the terminal is closed for service.

## Trigger Conditions

The terminal closed screen will automatically appear when the WebAPI returns either of these substates:
- **11043** - Terminal closed substate
- **11042** - Terminal closed substate

## Features

### 🎨 Visual Design
- **Almaya Header**: Consistent branding with "TERMINAL CLOSED" title
- **Terminal Icon**: Large terminal icon with lock overlay indicating closure
- **Professional Layout**: Orange color scheme indicating caution/closure
- **Bilingual Support**: English and Arabic text support

### 🔧 Functionality
- **Automatic Detection**: Monitors PosSubState changes in real-time
- **Popup Cleanup**: Closes any open popups when terminal closes
- **Staff Access**: Provides button for staff to access POS Cashier mode
- **Contact Staff**: Button to notify staff for assistance

### 📱 User Experience
- **Clear Messaging**: Explains why the terminal is unavailable
- **Alternative Options**: Suggests using another terminal or contacting staff
- **Status Information**: Shows current terminal status and time
- **Professional Appearance**: Maintains Almaya branding consistency

## Implementation Details

### Automatic Monitoring
```dart
void updatePosSubState(String state) {
  _posSubState.value = state;
  
  // Monitor for terminal closed substates
  if (state == '11043' || state == '11042') {
    navigateToTerminalClosed();
  }
}
```

### Navigation Integration
```dart
void navigateToTerminalClosed() {
  closeAllPopups(); // Close any open popups
  _navigateToScreen(AppScreen.terminalClosed);
}
```

### Screen Components
- **Header**: AlmayaHeader with "TERMINAL CLOSED" title
- **Main Icon**: Terminal with lock overlay
- **Status Info**: Terminal ID, substate, and current time
- **Action Buttons**: Contact staff and staff mode access

## Testing

### Manual Testing
You can test the terminal closed functionality using the test widget:

1. Navigate to the MQTT Test Widget
2. Click the orange "Test Terminal Closed" button
3. Check console output for detailed test results

### Programmatic Testing
```dart
// Test substate 11043
controller.simulateTerminalClosed('11043');

// Test substate 11042  
controller.simulateTerminalClosed('11042');
```

## Files Created/Modified

### New Files
- `lib/views/terminal_closed_page.dart` - Main terminal closed screen
- `lib/test/popup_test.dart` - Enhanced with terminal closed tests

### Modified Files
- `lib/models/app_state.dart` - Added `terminalClosed` to AppScreen enum
- `lib/controllers/app_controller.dart` - Added monitoring and navigation logic
- `lib/main.dart` - Added terminal closed page to navigation
- `lib/test/mqtt_test_widget.dart` - Added test button

## Integration with WebAPI

The terminal closed screen integrates seamlessly with your existing WebAPI service:

1. **WebAPI Response**: When API returns substate 11043 or 11042
2. **Automatic Detection**: `updatePosSubState()` method detects the closure
3. **Popup Cleanup**: All open popups are closed automatically
4. **Screen Display**: Terminal closed screen is shown immediately
5. **User Guidance**: Clear instructions for next steps

## Benefits

- **Immediate Feedback**: Users know instantly when terminal is unavailable
- **Professional Appearance**: Maintains brand consistency during closure
- **Clear Communication**: Bilingual support for diverse customers
- **Staff Support**: Easy access to staff assistance and POS mode
- **Automatic Handling**: No manual intervention required

The terminal closed screen ensures a professional and informative experience when the terminal needs to be taken offline for maintenance or other reasons.
