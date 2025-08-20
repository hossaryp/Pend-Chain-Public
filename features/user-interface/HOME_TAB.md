# Home Tab Feature Documentation

## Overview

The Home tab is the new default landing page for authenticated users in the Pend wallet application. It replaces the previous Welcome screen and provides a comprehensive dashboard for users to discover investment opportunities, access educational content, and engage with the community.

## Component Structure

### Location
- **Path**: `wallet-ui/src/features/home/components/HomeTab.tsx`
- **Type**: React Functional Component
- **Dependencies**: React Router, ExploreCard components, SVGIcons

## Key Features

### 1. Banner Carousel
- **Auto-rotation**: Banners change every 5 seconds
- **Touch Support**: Swipe gestures for mobile navigation
- **Content**: 
  - Investment opportunities promotion
  - Gold investments announcement
  - Community join CTA
- **Visual Design**: Gradient backgrounds with call-to-action buttons

### 2. Top Categories Section
- **Visual Cards**: Each category displays a high-quality image
- **Categories**:
  - Agriculture (farm landscape image)
  - Real Estate (modern building image)
  - Commodities (gold/precious metals image)
  - Solar Energy (solar panels image)
  - All Categories (overview image)
- **Interactions**: 
  - Hover effect scales image by 10%
  - Orange tint overlay on hover
  - Click navigates to filtered explore view

### 3. Top Assets by Category
- **Dynamic Content**: Displays top 3 opportunities per category
- **Responsive Grid**: 1 column mobile, 2-3 columns desktop
- **Loading States**: Skeleton loaders while fetching data
- **Integration**: Uses existing ExploreCard components

### 4. Learn with Pend
- **Dual Cards**:
  - Pend بالعربي: Arabic educational content
  - Pend Hub: English guides and tutorials
- **Visual Design**: Icons with descriptive text
- **External Links**: Opens in new tabs

### 5. Community Section
- **Social Media Integration**:
  - Telegram
  - Discord
  - WhatsApp
- **Design**: Gradient background with white icons
- **Call-to-Action**: "Join Now" button

### 6. Support CTA
- **Bottom Section**: Easy access to support
- **Visual**: Support icon with contact button
- **Purpose**: Quick help access for users

## Navigation Integration

### Bottom Navigation Updates
- **File**: `wallet-ui/src/shared/components/BottomNavBar.tsx`
- **Changes**:
  - Added "home" as first tab
  - Updated type definitions to include home
  - Home icon from lucide-react

### App Flow Changes
- **File**: `wallet-ui/src/App.tsx`
- **Changes**:
  - Removed step 0 (WelcomeScreen)
  - Changed initial step for new users to 1 (phone input)
  - Modified step 6 redirects to step 7 (home)
  - Removed success screen entirely

## SVG Icon System

### New Icons Created
Located in `wallet-ui/src/shared/components/icons/SVGIcons.tsx`:

1. **Category Icons**:
   - Farm: Agriculture representation
   - Building: Real estate
   - Gold: Commodities (gold bar icon)
   - Solar: Renewable energy (sun with rays)
   - Grid: All categories

2. **UI Icons**:
   - Book: Educational content
   - Globe: International/hub content
   - Support: Headset icon

3. **Social Icons**:
   - Telegram
   - Discord
   - WhatsApp

### Icon Design Principles
- Consistent 24x24 viewBox
- 2px stroke width
- Current color inheritance
- No fill, stroke-only design (except social icons)

## Mobile Optimization

### Responsive Design
- Mobile-first approach
- Horizontal scroll for categories with hidden scrollbar
- Stacked layout for all sections
- Touch-optimized interactions

### Performance
- Lazy loading for opportunity data
- Skeleton loaders for better perceived performance
- Optimized image sizes for category cards

## Data Integration

### Opportunities Loading
- Uses mock data from `exploreListings.json`
- Filters top 3 items per category
- Error handling with user-friendly messages

### State Management
- Local state for banner index
- Loading and error states
- Touch gesture tracking with refs

## User Experience Improvements

1. **Direct Access**: No intermediate screens after login
2. **Visual Discovery**: Images make categories more appealing
3. **Progressive Disclosure**: Start with overview, drill down to details
4. **Community Focus**: Easy access to social channels
5. **Support Visibility**: Help is always one tap away

## Future Enhancements

1. **Personalization**: Show categories based on user preferences
2. **Dynamic Banners**: Admin-controlled banner content
3. **Analytics**: Track category clicks and engagement
4. **Recommendations**: AI-driven opportunity suggestions
5. **Live Data**: Real-time opportunity updates

## Testing Considerations

1. **Component Tests**: 
   - Banner rotation timing
   - Touch gesture handling
   - Category click navigation

2. **Integration Tests**:
   - Navigation flow from home to explore
   - Data loading and error states
   - Responsive layout changes

3. **E2E Tests**:
   - Full user journey from login to home
   - Category filtering functionality
   - External link handling 