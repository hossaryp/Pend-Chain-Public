# Admin Panel Authentication Setup

## Overview
The admin panel now requires authentication for all endpoints using a simple header-based system that can be upgraded to JWT later.

## Setup Instructions

### 1. Server Configuration

Add the following to your server's `.env` file:

```bash
# Admin Panel Security
ADMIN_SECRET_KEY=your-very-secure-random-key-here
```

Generate a secure key:
```bash
# Option 1: Using OpenSSL
openssl rand -hex 32

# Option 2: Using Node.js
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

### 2. Admin Panel Configuration

Add the following to your admin panel's `.env.local` file:

```bash
# Must match the server's ADMIN_SECRET_KEY
NEXT_PUBLIC_ADMIN_KEY=your-very-secure-random-key-here
```

### 3. Testing Authentication

Test that authentication is working:

```bash
# This should fail with 401
curl http://localhost:3001/api/admin/assets

# This should succeed
curl -H "X-Admin-Key: your-very-secure-random-key-here" \
  http://localhost:3001/api/admin/assets
```

### 4. Development Setup

For local development, you can use the default key:
- Default key: `development-admin-key`
- This only works if `ADMIN_SECRET_KEY` is not set

**⚠️ WARNING: Never use the default key in production!**

## Security Notes

1. **Keep the admin key secret** - Never commit it to version control
2. **Use HTTPS in production** - Headers are visible in plain HTTP
3. **Rotate keys regularly** - Change the admin key periodically
4. **Monitor access logs** - Check `admin-logs.json` for unauthorized attempts

## Upgrading to JWT Authentication

The system is designed to upgrade to JWT authentication later:

1. Uncomment `requireAdminJWT` in `adminAuth.js`
2. Replace `requireAdmin` with `requireAdminJWT` in `admin.js`
3. Implement admin login endpoint
4. Update admin panel to use JWT tokens

## Troubleshooting

### 401 Unauthorized Errors
- Check that `X-Admin-Key` header is being sent
- Verify the key matches on both server and client
- Check server logs for detailed error messages

### Admin Panel Can't Connect
- Ensure `NEXT_PUBLIC_ADMIN_KEY` is set in `.env.local`
- Restart the Next.js development server after changing env vars
- Check browser console for fetch errors

### Access Logs
All admin access attempts are logged in `server/admin-logs.json`:
- Successful access: `ADMIN_ACCESS`
- Failed attempts: `ADMIN_AUTH_FAILED` 