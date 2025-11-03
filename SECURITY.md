# Security Best Practices

This document outlines the security measures implemented in this project.

## 🔒 Secrets Management

### 1. API Keys
- **TMDB API Key**: Passed via compile-time environment variable
  - Not hardcoded in source code
  - Passed using `--dart-define=TMDB_API_KEY=your_key`
  - Fallback value exists only for local development

### 2. Firebase Configuration
- **google-services.json**:
  - Contains Firebase project configuration
  - **Gitignored** - never committed to repository
  - Stored as base64-encoded GitHub Secret (`GOOGLE_SERVICES_JSON`)
  - Decoded during CI/CD build process only

- **Firebase Service Account**:
  - Stored in GitHub Secrets (`FIREBASE_SERVICE_ACCOUNT`)
  - Used only for Firebase App Distribution
  - Never exposed in logs or code

## 📋 GitHub Secrets Required

To run the CI/CD pipeline, add these secrets to your GitHub repository:

### Settings → Secrets and variables → Actions → New repository secret

1. **TMDB_API_KEY**
   - Your TMDB API key
   - Get from: https://www.themoviedb.org/settings/api

2. **GOOGLE_SERVICES_JSON**
   - Base64 encoded google-services.json file
   - Generate: `cat android/app/google-services.json | base64 -w 0`

3. **FIREBASE_SERVICE_ACCOUNT**
   - Firebase service account JSON
   - Get from: Firebase Console → Project Settings → Service Accounts → Generate new private key

## 🛡️ Security Checklist

### ✅ What's Protected:
- [x] API keys not hardcoded
- [x] Firebase config gitignored
- [x] Service account credentials in secrets
- [x] GitHub Actions use official actions only
- [x] Secrets masked in CI/CD logs
- [x] .env files gitignored

### ✅ What's Safe to Expose:
- [x] Firebase App ID (public identifier)
- [x] Package names
- [x] API endpoints (public URLs)
- [x] App version codes

## 🚨 Never Commit:
- `.env` files (API keys)
- `google-services.json` (Firebase config)
- `GoogleService-Info.plist` (iOS Firebase config)
- Service account JSON files
- Keystore files
- Private keys

## 📝 Git History Cleanup

If you accidentally committed secrets, follow these steps:

### 1. Remove from current commit:
```bash
git rm --cached path/to/secret/file
git commit -m "Remove sensitive file"
```

### 2. Regenerate compromised secrets:
- TMDB: Regenerate API key at https://www.themoviedb.org/settings/api
- Firebase: Create new service account and delete old one

### 3. Update GitHub Secrets with new values

## 🔐 Running Locally

### With Environment Variables:
```bash
# Dev flavor
flutter run --flavor dev --dart-define=FLAVOR=dev --dart-define=TMDB_API_KEY=your_key

# Prod flavor
flutter run --flavor prod --dart-define=FLAVOR=prod --dart-define=TMDB_API_KEY=your_key
```

### With VS Code:
The launch configurations in `.vscode/launch.json` are already set up with the API key parameter.

## 📊 Security Audit

Last security audit: 2025-11-03
Status: ✅ All secrets properly protected

### Findings:
- No hardcoded credentials in source code
- All sensitive files properly gitignored
- GitHub Actions secrets properly configured
- CI/CD pipeline uses secure secret injection

## 🆘 Reporting Security Issues

If you find a security vulnerability, please:
1. **DO NOT** open a public GitHub issue
2. Contact the maintainer directly
3. Provide details about the vulnerability
4. Allow time for the issue to be fixed before disclosure

---

**Remember**: Security is not a one-time task. Review this document regularly and update as needed.
