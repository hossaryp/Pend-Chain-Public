# Egyptian Phone Number Restriction

## Overview
The Pend platform has been updated to exclusively serve Egyptian residents by restricting user registration to Egyptian phone numbers only. This aligns with our mission to provide accessible investment opportunities specifically for the Egyptian market.

## Implementation Details

### UI Changes

#### Phone Number Screen (`wallet-ui/src/features/auth/components/PhoneNumberScreen.tsx`)
- **Removed Country Selector**: The dropdown for selecting countries has been replaced with a fixed Egyptian flag (🇪🇬) and +20 prefix
- **Hardcoded Egypt**: Only Egyptian phone numbers are accepted, no other countries available
- **Visual Indicators**: 
  - Blue notice box stating "Egyptian phone numbers only"
  - Updated subtitle: "Enter your Egyptian mobile number to create your wallet"
  - Fixed Egyptian flag emoji with +20 country code display
- **Error Messages**: Updated to specifically mention "Please enter a valid Egyptian phone number"

#### Welcome Screen (`wallet-ui/src/features/auth/components/WelcomeScreen.tsx`)
- **Title Update**: Changed to "Welcome to Pend Egypt — Invest in What Matters"
- **Subtitle Update**: "A safe, simple way for Egyptians to own real-world assets"
- **Egyptian Flag Indicator**: Added 🇪🇬 with text "Available for Egyptian residents only"
- **Carousel Update**: Changed "Access for All" to "Access for All Egyptians"

### Server-Side Validation

#### Phone Number Validation (`server/services/twilioService.js`)
- **Regex Pattern**: `/^\+20[0-9]{10}$/` - Only accepts +20 followed by exactly 10 digits
- **Validation Function**: `verifyPhoneNumber()` now exclusively validates Egyptian format
- **Logging**: Updated to indicate "Egyptian numbers only" in validation logs

#### OTP Route (`server/routes/otp.js`)
- **Pre-send Validation**: Added phone number validation before sending OTP
- **Error Response**: Returns "Only Egyptian phone numbers (+20) are allowed" for non-Egyptian numbers
- **Security**: Prevents OTP generation for invalid phone numbers

## Technical Specifications

### Egyptian Phone Number Format
- **Country Code**: +20
- **Length**: 10 digits after country code
- **Total Length**: 12 characters including country code
- **Format**: `+20XXXXXXXXXX` where X is a digit 0-9

### Validation Flow
1. Client-side validation in PhoneNumberScreen component
2. Server-side validation before OTP generation
3. Consistent error messages across client and server

## User Experience

### Registration Flow
1. User sees welcome screen indicating "Available for Egyptian residents only"
2. Phone input shows fixed Egyptian flag and +20 prefix
3. Blue notice box clearly states "Egyptian phone numbers only"
4. User enters 10-digit Egyptian mobile number
5. Real-time validation shows green checkmark for valid numbers
6. Clear error message for invalid formats

### Visual Design
- Egyptian flag emoji (🇪🇬) used consistently
- Blue information boxes for clear communication
- Updated copy throughout to reference Egyptian users
- Professional, trust-building design maintained

## Migration Considerations

### Existing Users
- Users with non-Egyptian phone numbers will be unable to log in
- Consider migration strategy for existing international users if any

### Test Data
- Cypress tests already use Egyptian numbers (+201234567890)
- Update any remaining test data to use Egyptian format

## Benefits
1. **Regulatory Compliance**: Easier to comply with Egyptian financial regulations
2. **Market Focus**: Clear positioning as an Egyptian investment platform
3. **User Trust**: Egyptian users feel the platform is built specifically for them
4. **Simplified Operations**: Single country focus reduces complexity

## Future Considerations
- Arabic language support enhancement
- Integration with Egyptian payment systems (InstaPay)
- Local customer support in Egyptian time zones
- Partnerships with Egyptian financial institutions 