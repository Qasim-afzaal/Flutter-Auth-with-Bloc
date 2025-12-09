# Setting Up CI/CD Pipelines

Quick setup guide to get your CI/CD pipelines running.

## 🚀 Quick Start

### 1. Push to GitHub
The workflows are already configured! Just push your code:

```bash
git add .
git commit -m "feat: add CI/CD pipelines"
git push origin main
```

### 2. View Your Pipelines
1. Go to your GitHub repository
2. Click on the **Actions** tab
3. You'll see your workflows running!

## 📋 What's Included

### Workflows Created:

1. **`ci.yml`** - Full CI pipeline
   - Code quality checks
   - Runs tests
   - Builds Android, iOS, Web
   - Runs on every push/PR

2. **`cd.yml`** - Deployment pipeline
   - Deploys to staging (automatic)
   - Deploys to production (on tags)
   - Runs after successful CI

3. **`quick-check.yml`** - Fast validation
   - Quick checks for PRs
   - Faster feedback
   - No full builds

## ⚙️ Configuration Steps

### Step 1: Verify Flutter Version
Check your Flutter version:
```bash
flutter --version
```

Update in workflows if needed:
```yaml
# In .github/workflows/*.yml
flutter-version: '3.24.0'  # Change to your version
```

### Step 2: Add Secrets (Optional)
If you need API keys or tokens:

1. Go to GitHub → Your Repo → **Settings**
2. Click **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add your secrets:
   - `API_BASE_URL` - Your API base URL
   - `FIREBASE_SERVICE_ACCOUNT` - For Firebase deployment
   - `GOOGLE_PLAY_SERVICE_ACCOUNT` - For Play Store deployment

### Step 3: Customize Deployment (Optional)
Edit `.github/workflows/cd.yml` to add your deployment:

**For Firebase Hosting:**
```yaml
- name: Deploy to Firebase
  uses: FirebaseExtended/action-hosting-deploy@v0
  with:
    firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
    projectId: your-project-id
```

**For Google Play:**
```yaml
- name: Deploy to Play Store
  uses: r0adkll/upload-google-play@v1
  with:
    serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
    packageName: com.yourapp.package
    releaseFiles: build/app/outputs/flutter-apk/app-release.apk
    track: internal
```

## 🧪 Testing Locally

Before pushing, test your builds locally:

```bash
# Test Android build
flutter build apk --release

# Test iOS build (macOS only)
flutter build ios --release --no-codesign

# Test Web build
flutter build web --release

# Run tests
flutter test

# Check code quality
flutter analyze
```

## 📊 Understanding Workflow Status

### Status Badges
Add to your README.md:
```markdown
![CI](https://github.com/yourusername/yourrepo/workflows/CI%20Pipeline/badge.svg)
```

### Status Colors:
- 🟢 **Green**: All checks passed
- 🟡 **Yellow**: In progress
- 🔴 **Red**: Failed
- ⚪ **Gray**: Skipped

## 🐛 Troubleshooting

### Pipeline Not Running?
1. Check if `.github/workflows/` folder exists
2. Verify YAML syntax (no tabs, use spaces)
3. Check branch name matches workflow triggers

### Build Fails?
1. Check logs in Actions tab
2. Verify Flutter version matches
3. Test build locally first

### Tests Fail?
1. Run `flutter test` locally
2. Check test output
3. Fix failing tests

### Secrets Not Working?
1. Verify secret name matches exactly
2. Check secret is set in repository settings
3. Use correct syntax: `${{ secrets.SECRET_NAME }}`

## 🎯 Common Customizations

### Change Trigger Branches
```yaml
on:
  push:
    branches: [ main, develop, feature/* ]  # Add your branches
```

### Add Environment Variables
```yaml
env:
  ENV: production
  API_URL: ${{ secrets.API_URL }}
```

### Add Caching (Faster Builds)
```yaml
- name: Cache Flutter dependencies
  uses: actions/cache@v3
  with:
    path: |
      ~/.pub-cache
      build/
    key: ${{ runner.os }}-flutter-${{ hashFiles('**/pubspec.lock') }}
```

### Schedule Nightly Builds
```yaml
on:
  schedule:
    - cron: '0 0 * * *'  # Daily at midnight UTC
```

## 📚 Next Steps

1. ✅ Push code and watch pipelines run
2. ✅ Download artifacts (APK, builds)
3. ✅ Set up secrets for deployment
4. ✅ Customize for your deployment needs
5. ✅ Add status badges to README

## 🔗 Useful Links

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter CI/CD Guide](https://docs.flutter.dev/deployment/cd)
- [GitHub Actions Marketplace](https://github.com/marketplace?type=actions)

---

**You're all set!** Push your code and watch the magic happen! 🚀

