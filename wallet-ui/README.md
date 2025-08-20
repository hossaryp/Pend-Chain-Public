# Smart Wallet UI

A modern, mobile-first React wallet application built with TypeScript, featuring secure authentication, deposit management, and blockchain integration. **Recently restructured for enhanced scalability and mobile optimization.**

## 🎯 Recent Updates (December 2024)

✅ **Complete Architecture Restructuring**: Implemented feature-based modular architecture for better team scalability  
✅ **Fixed Deposit History**: Now uses real API endpoints (`/api/explorer/transactions`) instead of mock data  
✅ **Mobile-First Design System**: Comprehensive CSS system with 44px touch targets and responsive utilities  
✅ **Enhanced API Integration**: Centralized services with proper error handling and retry logic

## 🏗️ Project Architecture

This project follows a feature-based modular architecture optimized for scalability and maintainability.

### 📁 Folder Structure

```
src/
├── app/                    # App-level components and configuration
│   ├── components/         # Core app components (Home, Tabs, etc.)
│   └── context/           # App-wide context providers
├── features/              # Feature-based modules
│   ├── auth/             # Authentication feature
│   │   ├── components/   # Auth components (Login, OTP, etc.)
│   │   ├── hooks/        # Auth-specific hooks
│   │   └── services/     # Auth API services
│   ├── wallet/           # Wallet management feature
│   │   ├── components/   # Wallet components
│   │   ├── hooks/        # Wallet hooks
│   │   └── services/     # Wallet services
│   ├── deposit/          # Deposit functionality
│   │   ├── components/   # Deposit components
│   │   ├── hooks/        # Deposit hooks
│   │   └── services/     # Deposit services
│   ├── harvest/          # Investment/harvest feature
│   └── explore/          # Explore/discovery feature
├── shared/               # Shared utilities and components
│   ├── components/       # Reusable UI components
│   ├── hooks/           # Custom React hooks
│   ├── services/        # API services and utilities
│   ├── utils/           # Utility functions
│   ├── types/           # TypeScript type definitions
│   └── constants/       # App constants and configurations
├── assets/              # Static assets (images, icons, etc.)
└── styles/              # Global styles and design system
```

## 📱 Mobile-First Design

This application is built with a mobile-first approach, ensuring optimal user experience across all devices.

### Key Mobile Features

- **Touch-Optimized Interface**: All interactive elements meet 44px minimum touch target requirements
- **Responsive Design**: Fluid layouts that adapt to various screen sizes
- **Performance Optimized**: Lazy loading, efficient state management, and optimized bundle sizes
- **PWA Ready**: Can be installed as a Progressive Web App on mobile devices
- **Gesture Support**: Native mobile gestures and interactions

### Design System

The application uses a comprehensive design system located in `src/styles/mobile.css` with:

- Consistent spacing scale (rem-based)
- Mobile-optimized typography
- Touch-friendly button states
- Accessible color contrasts
- Smooth animations and transitions

## 🚀 Getting Started

### Prerequisites

- Node.js 18+ 
- npm or yarn
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone [repository-url]
   cd wallet-ui
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Start development server**
   ```bash
   npm run dev
   ```

4. **Build for production**
   ```bash
   npm run build
   ```

## 🛠️ Technology Stack

### Core Technologies
- **React 18** - UI library with concurrent features
- **TypeScript** - Type safety and developer experience
- **Vite** - Fast build tool and development server
- **Tailwind CSS** - Utility-first CSS framework

### Mobile & PWA
- **Capacitor** - Native mobile app deployment
- **PWA Capabilities** - Offline support and app-like experience

### State Management
- **React Context** - Global state management
- **Custom Hooks** - Reusable stateful logic

### API & Blockchain
- **Ethers.js** - Ethereum blockchain interaction
- **Axios** - HTTP client for API calls
- **React Hot Toast** - User notifications

### Development Tools
- **ESLint** - Code linting
- **Prettier** - Code formatting
- **TypeScript** - Static type checking

## 🔧 Development Guidelines

### Code Organization

1. **Feature-Based Structure**: Group related components, hooks, and services by feature
2. **Shared Resources**: Place reusable components and utilities in the `shared` folder
3. **Type Safety**: Use TypeScript for all components and functions
4. **Mobile-First**: Design for mobile devices first, then enhance for larger screens

### Component Patterns

```typescript
// Example component structure
import React from 'react';
import { Button } from '../../shared/components/Button';
import { useWallet } from '../../shared/hooks/useWallet';
import type { WalletProps } from '../../shared/types';

interface ComponentProps {
  // Define props with TypeScript
}

export const Component: React.FC<ComponentProps> = ({ prop1, prop2 }) => {
  // Component logic here
  
  return (
    <div className="mobile-container">
      {/* JSX content */}
    </div>
  );
};

export default Component;
```

### Styling Guidelines

1. **Use Tailwind Classes**: Leverage utility classes for consistent styling
2. **Mobile-First Responsive**: Start with mobile styles, add larger screen styles with breakpoint prefixes
3. **Touch Targets**: Ensure all interactive elements are at least 44px
4. **Accessibility**: Include proper ARIA labels and focus states

### API Integration

```typescript
// Use the centralized API services
import { depositAPI } from '../../shared/services/api';

const handleDeposit = async (amount: string) => {
  try {
    const result = await depositAPI.depositEGP({
      amount,
      phone: phoneNumber,
      wallet: walletAddress,
    });
    // Handle success
  } catch (error) {
    // Handle error
  }
};
```

## 📋 Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm run lint` - Run ESLint
- `npm run type-check` - Run TypeScript compiler check

## 🎨 Design System

### Colors
- **Primary**: `#FF8A34` (Orange)
- **Success**: `#10B981` (Green)
- **Error**: `#EF4444` (Red)
- **Warning**: `#F59E0B` (Yellow)

### Typography Scale
- **xs**: 0.75rem (12px)
- **sm**: 0.875rem (14px)
- **base**: 1rem (16px)
- **lg**: 1.125rem (18px)
- **xl**: 1.25rem (20px)
- **2xl**: 1.5rem (24px)

### Spacing Scale
- **xs**: 0.25rem (4px)
- **sm**: 0.5rem (8px)
- **md**: 1rem (16px)
- **lg**: 1.5rem (24px)
- **xl**: 2rem (32px)

## 🔒 Security Features

- **Biometric Authentication**: WebAuthn integration for secure access
- **Encrypted Storage**: Sensitive data protection
- **Device Fingerprinting**: Enhanced security measures
- **Secure Communication**: HTTPS/WSS for all API calls

## 📱 Mobile App Deployment

### Android

1. **Add Android platform**
   ```bash
   npx cap add android
   ```

2. **Build and sync**
   ```bash
   npm run build
   npx cap sync android
   ```

3. **Open in Android Studio**
   ```bash
   npx cap open android
   ```

### iOS

1. **Add iOS platform**
   ```bash
   npx cap add ios
   ```

2. **Build and sync**
   ```bash
   npm run build
   npx cap sync ios
   ```

3. **Open in Xcode**
   ```bash
   npx cap open ios
   ```

## 🧪 Testing

### Component Testing
```bash
npm run test
```

### E2E Testing
```bash
npm run test:e2e
```

## 📈 Performance Optimization

- **Code Splitting**: Automatic route-based splitting
- **Lazy Loading**: Components loaded on demand
- **Image Optimization**: WebP format with fallbacks
- **Bundle Analysis**: Use `npm run analyze` to inspect bundle size

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Follow the established patterns and coding standards
4. Write tests for new functionality
5. Commit changes (`git commit -am 'Add new feature'`)
6. Push to branch (`git push origin feature/new-feature`)
7. Create a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions, please open an issue in the repository or contact the development team.

---

**Built with ❤️ for the future of digital wallets** 