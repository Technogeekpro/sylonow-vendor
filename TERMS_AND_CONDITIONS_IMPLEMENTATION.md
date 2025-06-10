# Terms and Conditions Implementation Guide

## Overview
This document outlines the implementation of mandatory Terms & Conditions, Revenue Policy, and Privacy Policy acceptance in the Sylonow Vendor App.

## Implementation Summary

### 1. **New Screens Created**

#### Terms & Conditions Screen (`lib/features/onboarding/screens/terms_conditions_screen.dart`)
- **Route**: `/terms-conditions`
- **Content**: Complete Terms and Conditions document with 14 sections
- **Features**:
  - Scrollable content with proper formatting
  - Professional UI with gradient header
  - Section-wise organization
  - Back navigation
  - Responsive design

#### Revenue & Commission Policy Screen (`lib/features/onboarding/screens/revenue_policy_screen.dart`)
- **Route**: `/revenue-policy`
- **Content**: Comprehensive Revenue & Commission Policy (EUL) with 12 sections
- **Features**:
  - Highlighted vendor earnings section (95% of TOV)
  - Penalty table with structured layout
  - Professional formatting
  - Contact information
  - Legal compliance details

#### Privacy Policy Screen (`lib/features/onboarding/screens/privacy_policy_screen.dart`)
- **Route**: `/privacy-policy`
- **Content**: Complete Privacy Policy with 12 sections covering data collection, usage, and rights
- **Features**:
  - Comprehensive data collection information
  - QR-based verification security section (highlighted)
  - User rights under Indian law
  - Enhanced contact section with icons
  - Data security and retention policies

### 2. **Welcome Screen Updates**

#### Mandatory Terms Acceptance Checkbox
- **Location**: Above authentication buttons
- **Features**:
  - Custom checkbox with visual feedback
  - Links to Terms & Conditions, Revenue Policy, and Privacy Policy
  - Quick access buttons to view policies
  - Required field indicator
  - State management for acceptance

#### Enhanced Privacy Section
- **Location**: Bottom of screen
- **Features**:
  - Clickable privacy link leading to Privacy Policy
  - Side-by-side Privacy Policy and Cookies Policy buttons
  - Improved visual design with smaller, cleaner buttons
  - Better user experience with clear navigation

#### Authentication Flow Changes
- **Google Sign-In**: Disabled until terms are accepted
- **Mobile Sign-In**: Disabled until terms are accepted
- **Visual Feedback**: Buttons become grayed out when terms not accepted
- **Error Handling**: Dialog shown if user tries to sign in without accepting terms

### 3. **Router Configuration Updates**

#### New Public Routes Added
```dart
GoRoute(
  path: '/terms-conditions',
  builder: (_, __) => const TermsConditionsScreen(),
),
GoRoute(
  path: '/revenue-policy',
  builder: (_, __) => const RevenuePolicyScreen(),
),
GoRoute(
  path: '/privacy-policy',
  builder: (_, __) => const PrivacyPolicyScreen(),
),
```

#### Route Protection
- All policy screens are accessible without authentication
- Added to public routes list in redirect logic

## User Experience Flow

### 1. **Welcome Screen**
1. User sees welcome screen with authentication options
2. Terms acceptance checkbox is prominently displayed
3. Authentication buttons are disabled (grayed out)
4. User must check the terms acceptance checkbox

### 2. **Terms Acceptance Process**
1. User can click on "Terms & Conditions" or "Revenue Policy" links
2. Opens respective screen in new route
3. User can read complete document
4. User returns to welcome screen
5. User checks the acceptance checkbox
6. Authentication buttons become enabled

### 3. **Authentication Attempt Without Terms**
1. If user tries to sign in without accepting terms
2. Dialog appears: "Terms Required"
3. Options: Cancel or View Terms
4. User is guided to accept terms before proceeding

### 4. **Successful Authentication**
1. Terms accepted + authentication successful
2. User proceeds to normal app flow
3. Terms acceptance is enforced at entry point

## Technical Implementation Details

### State Management
```dart
bool _termsAccepted = false; // Tracks acceptance state
```

### Terms Validation
```dart
Future<void> _signInWithGoogle() async {
  if (!_termsAccepted) {
    _showTermsRequiredDialog();
    return;
  }
  // Proceed with authentication...
}
```

### UI Components

#### Terms Checkbox Widget
- Custom checkbox with visual states
- Clickable text links to policy screens
- Required field indicator
- Professional styling

#### Policy Buttons
- Quick access to view policies
- Icon + text layout
- Consistent theming

#### Warning Dialog
- Shown when terms not accepted
- Clear call-to-action
- Professional design

## Content Structure

### Terms & Conditions (14 Sections)
1. Acceptance of Terms
2. Definitions
3. Vendor Responsibilities (5-step process)
4. Payment Structure
5. Cancellation & Compensation
6. Use of App & Account
7. Liability & Indemnification
8. Data Sharing & Privacy
9. Intellectual Property
10. Compliance & Conduct
11. Termination
12. Governing Law
13. Dispute Resolution
14. Contact Information

### Revenue & Commission Policy (12 Sections)
1. Introduction
2. Revenue Distribution (95% vendor share)
3. Additional Charges (Non-Shareable)
4. Vendor Wallet & Payment Schedule
5. Taxation & Compliance
6. Deductions & Penalties (Table format)
7. Order Cancellations
8. Refund Policy Impact
9. Fraud & Security Breaches
10. Dispute Resolution
11. Legal Protections & Limitation of Liability
12. Governing Law & Jurisdiction

### Privacy Policy (12 Sections)
1. Introduction
2. Information We Collect (Personal, Vendor-Specific, Device & Usage, Payment Data)
3. How We Use Your Information
4. Data Sharing and Disclosure
5. QR-Based Vendor Verification (Highlighted Security Section)
6. Data Security
7. Cookies and Tracking Technology
8. Your Rights Under Indian Law
9. Retention of Data
10. Children's Privacy
11. Changes to This Privacy Policy
12. Contact Us (Enhanced with icons and contact details)

## Key Features

### ✅ **Mandatory Acceptance**
- Cannot proceed without accepting terms
- Visual feedback for acceptance state
- Clear error messaging

### ✅ **Professional UI**
- Consistent with app theme
- Gradient headers
- Proper typography
- Responsive design

### ✅ **Easy Access**
- Direct links from welcome screen
- Quick access buttons
- Smooth navigation

### ✅ **Legal Compliance**
- Complete terms document
- Revenue policy details
- Contact information
- Governing law specified

### ✅ **User-Friendly**
- Clear section organization
- Readable formatting
- Intuitive navigation
- Professional presentation

## Testing Checklist

### Functional Testing
- [ ] Terms checkbox toggles correctly
- [ ] Authentication buttons disabled when terms not accepted
- [ ] Authentication buttons enabled when terms accepted
- [ ] Terms screens load correctly
- [ ] Navigation between screens works
- [ ] Warning dialog appears when needed
- [ ] Links in terms text work correctly

### UI Testing
- [ ] Responsive design on different screen sizes
- [ ] Proper theming and colors
- [ ] Text readability
- [ ] Button states (enabled/disabled)
- [ ] Animation smoothness
- [ ] Loading states

### Integration Testing
- [ ] Router navigation works correctly
- [ ] State persistence during navigation
- [ ] Authentication flow after terms acceptance
- [ ] Error handling scenarios

## Future Enhancements

### Potential Improvements
1. **Terms Version Tracking**: Track which version of terms user accepted
2. **Persistent Storage**: Remember terms acceptance across app sessions
3. **Update Notifications**: Notify users when terms are updated
4. **Analytics**: Track terms acceptance rates
5. **Localization**: Support multiple languages
6. **Accessibility**: Enhanced accessibility features

### Database Integration
```sql
-- Future table for tracking terms acceptance
CREATE TABLE vendor_terms_acceptance (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  vendor_id UUID REFERENCES vendors(id),
  terms_version VARCHAR(10),
  policy_version VARCHAR(10),
  accepted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  ip_address INET,
  user_agent TEXT
);
```

## Compliance Notes

### Legal Requirements Met
- ✅ Clear terms presentation
- ✅ Mandatory acceptance before service use
- ✅ Easy access to full terms
- ✅ Revenue sharing transparency
- ✅ Contact information provided
- ✅ Governing law specified
- ✅ Dispute resolution process outlined

### Best Practices Followed
- ✅ Terms presented before authentication
- ✅ Cannot bypass acceptance requirement
- ✅ Clear and readable formatting
- ✅ Professional presentation
- ✅ Easy navigation and access
- ✅ Consistent with app design

## Contact Information
For any questions regarding this implementation:
- **Email**: info@sylonow.com
- **Phone**: +91-9480709432
- **Address**: JP Nagar Bengaluru 560078 