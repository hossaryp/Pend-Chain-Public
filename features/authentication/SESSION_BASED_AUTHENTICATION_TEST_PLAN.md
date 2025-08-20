# Session-Based Authentication Test Plan

## 🎯 **Phase 4: Testing & Validation**

### **Test Environment Status**
- ✅ Backend Server: Running on http://localhost:3001
- ✅ Frontend Server: Running on http://localhost:5173
- ✅ Session API: Responding correctly
- ✅ Build Status: Clean compilation

---

## 🧪 **Test Scenarios**

### **Scenario 1: New User Registration Flow**
**Objective**: Validate complete new user journey with wallet and PIN creation

**Steps:**
1. 📱 **Phone Entry**: Enter new phone number (+201098164XXX)
2. ✅ **Accept Terms**: Check terms and conditions
3. 📤 **Send OTP**: Click "Send me the code"
4. 📨 **Receive OTP**: Check console for OTP code (e.g., 684847)
5. 🔐 **Verify OTP**: Enter OTP and click "Verify and continue"
6. 💳 **Session Creation**: Backend creates wallet automatically
7. 📌 **PIN Creation**: Route to PIN creation (no existing PIN)
8. 🔒 **PIN Confirmation**: Confirm PIN setup
9. 🏠 **Authentication Complete**: Access authenticated app

**Expected Results:**
```
Console Logs:
📤 OTP sent successfully
🔐 Creating session with OTP...
✅ Session created: +20109816****
🔍 Checking PIN status...
📌 PIN Status: { exists: false }
🆕 New user - routing to PIN creation
📝 PIN created, moving to confirmation
💾 Storing PIN with FRA compliance...
✅ PIN setup complete - authentication successful!
🏠 Authenticated app loaded for user: +20109816****
```

---

### **Scenario 2: Existing User Login Flow**
**Objective**: Validate returning user login with existing PIN

**Steps:**
1. 📱 **Phone Entry**: Enter existing phone number
2. ✅ **Accept Terms**: Check terms and conditions
3. 📤 **Send OTP**: Click "Send me the code"
4. 📨 **Receive OTP**: Check console for OTP code
5. 🔐 **Verify OTP**: Enter OTP and click "Verify and continue"
6. 💳 **Session Restoration**: Backend finds existing wallet
7. 📌 **PIN Login**: Route to PIN login (existing PIN found)
8. 🔒 **PIN Authentication**: Enter existing PIN
9. 🏠 **Authentication Complete**: Access authenticated app

**Expected Results:**
```
Console Logs:
📤 OTP sent successfully
🔐 Creating session with OTP...
✅ Session created: +20109816****
🔍 Checking PIN status...
📌 PIN Status: { exists: true, pinFormat: "argon2_fra_compliant" }
👤 Existing user - routing to PIN login
✅ PIN login successful - authentication complete!
🏠 Authenticated app loaded for user: +20109816****
```

---

### **Scenario 3: Session Persistence**
**Objective**: Validate session survives page refresh

**Steps:**
1. ✅ **Complete Authentication**: Follow Scenario 1 or 2
2. 🔄 **Refresh Page**: Press F5 or Cmd+R
3. ⏳ **Session Check**: AuthContext checks existing session
4. 🏠 **Direct Access**: Skip auth flow, go directly to app

**Expected Results:**
```
Console Logs:
⏳ Session loading...
✅ User authenticated: +20109816****
💳 Wallet: 0x377B06...F50E
🔐 Capabilities: { biometric: false, pinSet: true, deviceRegistered: false }
🏠 Authenticated app loaded for user: +20109816****
```

---

### **Scenario 4: Session Expiry**
**Objective**: Validate proper handling of expired sessions

**Steps:**
1. ✅ **Authentication**: Complete login flow
2. ⏰ **Wait for Expiry**: Wait 15+ minutes (access token expiry)
3. 🔄 **Make API Call**: Try to access protected resource
4. 🔄 **Token Refresh**: System should auto-refresh tokens
5. ❌ **Refresh Failure**: If refresh token expired, redirect to login

**Expected Results:**
- Auto-refresh: User stays authenticated
- Expired refresh: Redirect to phone entry screen

---

## 🔧 **Debug Tools**

### **Console Logging**
Enhanced authentication flow includes comprehensive debug logging:

```javascript
// Session State
⏳ Session loading...
✅ User authenticated: +20109816****
❌ User not authenticated

// Authentication Flow
📤 OTP sent successfully
🔐 Creating session with OTP...
✅ Session created: +20109816****
🔍 Checking PIN status...
📌 PIN Status: { exists: true/false }

// Routing Decisions
👤 Existing user - routing to PIN login
🆕 New user - routing to PIN creation
🏠 Authenticated app loaded for user: +20109816****
```

### **Network Tab Monitoring**
Key API calls to monitor:

1. `POST /api/otp/send-otp` → 200 OK
2. `POST /api/auth/session/create` → 200 OK (returns session data)
3. `POST /api/pin/check-pin-exists` → 200 OK (returns PIN status)
4. `GET /api/auth/session/status` → 200 OK (session validation)

### **Session Storage Inspection**
Check localStorage for session tokens:
- `session_access_token`: JWT access token
- `session_refresh_token`: JWT refresh token
- `session_expires_at`: Token expiry timestamp

---

## ✅ **Success Criteria**

### **Functional Requirements**
- [ ] OTP generation and verification working
- [ ] Session creation with wallet management
- [ ] PIN status detection and proper routing
- [ ] New user PIN creation flow
- [ ] Existing user PIN login flow
- [ ] Session persistence across page refreshes
- [ ] Automatic token refresh handling
- [ ] Proper error handling and user feedback

### **Performance Requirements**
- [ ] Session creation under 5 seconds
- [ ] Page refresh under 2 seconds
- [ ] Smooth transitions between auth steps
- [ ] No UI flickering or state inconsistencies

### **Security Requirements**
- [ ] OTP validation on backend
- [ ] JWT tokens with proper expiry
- [ ] PIN hashing with FRA compliance
- [ ] Session invalidation on logout
- [ ] HTTPS-only cookies in production

---

## 🚀 **Ready for Testing**

The enhanced Phase 4 authentication flow is now ready for comprehensive testing:

1. **Backend**: All session endpoints functional
2. **Frontend**: Enhanced authentication flow with debug logging
3. **Integration**: Seamless OTP → Session → PIN → App flow
4. **Debugging**: Comprehensive console logging for troubleshooting

**Next Steps:**
1. Test both new user and existing user flows
2. Validate session persistence and refresh
3. Test error scenarios and edge cases
4. Prepare for production deployment 