# Global Header & Navigation System

## Overview

The Pend wallet app now features a unified global header with integrated profile, settings, and notification systems, providing consistent navigation across all screens.

## Components Added

### 1. **GlobalHeader** (`wallet-ui/src/components/GlobalHeader.tsx`)
- Fixed header with consistent navigation
- Profile icon (left), "pend" logo with beta badge (center), notification bell + settings (right)
- Context-aware: Shows back button and "Settings" title when in settings view
- Mobile-optimized with proper spacing and tap targets

### 2. **NotificationModal** (`wallet-ui/src/components/NotificationModal.tsx`)
- Floating notification center
- Displays success/pending notifications with visual indicators
- Clear All functionality
- Backdrop click or ESC to close

### 3. **NotificationContext** (`wallet-ui/src/context/NotificationContext.tsx`)
- Global notification state management
- Mock notifications for testing
- Actions: add, clearAll, markAllRead

## Key Changes

### Removed Duplicate Headers
- Eliminated header from `Home.tsx` component
- Removed header from `SettingsTab.tsx`
- Consolidated all navigation into the global header

### Profile Integration
- Changed from avatar with initials to clean profile icon
- Profile menu accessible from any screen
- Consistent with other navigation icons

### Settings Integration  
- Settings accessible via icon in global header
- Settings view shows contextual header with back button
- Seamless navigation between app sections

## Implementation Details

```tsx
// Global header structure
<header>
  <User icon />  // Profile
  <"pend" + beta badge />  // Centered brand
  <Bell icon + Settings icon />  // Actions
</header>
```

## Benefits

1. **Consistency** - Single navigation pattern across all screens
2. **Accessibility** - All key features accessible from any screen
3. **Mobile-first** - Optimized for 375px viewport width
4. **Clean UI** - No duplicate headers or conflicting navigation
5. **Future-ready** - Easy to add more header actions

## Testing

Cypress tests added in `cypress/e2e/05-global-header.cy.ts` covering:
- Header visibility
- Notification functionality
- Modal interactions
- Mobile responsiveness 