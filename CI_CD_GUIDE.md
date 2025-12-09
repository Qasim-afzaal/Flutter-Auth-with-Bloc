# CI/CD Pipeline Guide

This guide explains CI/CD pipelines, how they work, and how to use them in this project.

## 📚 What is CI/CD?

### CI (Continuous Integration)
- **Definition**: Automatically test and build your code whenever you push changes
- **Purpose**: Catch bugs early, ensure code quality, verify builds work
- **When**: Runs on every push/PR

### CD (Continuous Deployment)
- **Definition**: Automatically deploy your app after successful CI
- **Purpose**: Release updates quickly and reliably
- **When**: Runs after successful CI (usually on main branch)

## 🔄 The Complete Flow

```
Developer pushes code
        ↓
   CI Pipeline runs
        ↓
   ┌────┴────┐
   │         │
   ✅ Pass   ❌ Fail
   │         │
   ↓         ↓
Deploy    Notify team
   ↓
App goes live!
```

## 📁 Files in This Project

### 1. `.github/workflows/ci.yml`
**Purpose**: Runs on every push/PR
**Jobs**:
- ✅ Code Quality (linting, formatting)
- ✅ Run Tests
- ✅ Build Android APK
- ✅ Build iOS
- ✅ Build Web

### 2. `.github/workflows/cd.yml`
**Purpose**: Deploys after successful CI
**Jobs**:
- 🚀 Deploy to Staging (automatic on main)
- 🚀 Deploy to Production (on tags or manual)

## 🎯 How It Works

### Step 1: Push Code
```bash
git add .
git commit -m "feat: add new feature"
git push origin main
```

### Step 2: CI Pipeline Triggers
GitHub Actions automatically:
1. Checks out your code
2. Sets up Flutter environment
3. Runs all jobs in parallel

### Step 3: Jobs Run
- **Code Quality**: Checks for errors, formatting
- **Tests**: Runs unit/widget tests
- **Builds**: Creates APK, iOS, Web builds

### Step 4: Results
- ✅ **Success**: All checks pass, artifacts uploaded
- ❌ **Failure**: Error shown, deployment blocked

### Step 5: CD Pipeline (if CI passes)
- Deploys to staging automatically
- Deploys to production on tags/manual trigger

## 🔍 Understanding the CI Workflow

### Triggers
```yaml
on:
  push:
    branches: [ main, develop ]  # Run on push to these branches
  pull_request:                   # Run on PRs
  workflow_dispatch:              # Manual trigger
```

### Jobs
Each job runs independently (can run in parallel):

```yaml
jobs:
  test:
    runs-on: ubuntu-latest  # Linux runner
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
      - name: Run tests
        run: flutter test
```

### Steps
1. **Checkout**: Get code from repository
2. **Setup**: Install Flutter SDK
3. **Install**: Get dependencies (`flutter pub get`)
4. **Run**: Execute commands (test, build, etc.)
5. **Upload**: Save artifacts (APK, builds)

## 🚀 How to Use

### 1. View Pipeline Status
- Go to GitHub → Actions tab
- See all workflow runs
- Click on a run to see details

### 2. Download Artifacts
- After successful build, artifacts are available
- Go to Actions → Select run → Artifacts section
- Download APK, iOS build, or web build

### 3. Manual Trigger
- Go to Actions → Select workflow
- Click "Run workflow"
- Choose branch and run

### 4. View Logs
- Click on any job/step
- See detailed logs
- Debug failures

## 🔧 Customization

### Add Environment Variables
```yaml
env:
  API_BASE_URL: ${{ secrets.API_BASE_URL }}
  FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
```

### Add Secrets
1. Go to GitHub → Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add your secrets (API keys, tokens, etc.)

### Change Flutter Version
```yaml
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.24.0'  # Change this
```

### Add More Tests
```yaml
- name: Run integration tests
  run: flutter test integration_test/
```

## 📊 Common Use Cases

### 1. Pre-commit Checks
Run before merging PR:
- Code quality
- Tests
- Build verification

### 2. Nightly Builds
Schedule builds:
```yaml
on:
  schedule:
    - cron: '0 0 * * *'  # Daily at midnight
```

### 3. Release Builds
Build on version tags:
```yaml
on:
  push:
    tags:
      - 'v*'  # v1.0.0, v2.0.0, etc.
```

### 4. Multi-Environment
Build for different environments:
```yaml
- name: Build Staging
  run: flutter build apk --dart-define=ENV=staging

- name: Build Production
  run: flutter build apk --dart-define=ENV=production
```

## 🎓 Key Concepts

### 1. **Runners**
- Virtual machines that run your jobs
- `ubuntu-latest`: Linux (free, fast)
- `macos-latest`: macOS (for iOS builds)
- `windows-latest`: Windows

### 2. **Artifacts**
- Files produced by builds (APK, AAB, etc.)
- Stored for 7 days (configurable)
- Can be downloaded from Actions tab

### 3. **Secrets**
- Secure storage for sensitive data
- API keys, tokens, passwords
- Never exposed in logs

### 4. **Matrix Strategy**
Run same job on multiple versions:
```yaml
strategy:
  matrix:
    flutter-version: ['3.22.0', '3.24.0', 'stable']
```

### 5. **Conditional Jobs**
Run jobs based on conditions:
```yaml
if: github.ref == 'refs/heads/main'
```

## 🐛 Troubleshooting

### Build Fails
1. Check logs in Actions tab
2. Look for error messages
3. Test locally: `flutter build apk`
4. Fix issues and push again

### Tests Fail
1. Run tests locally: `flutter test`
2. Check test output
3. Fix failing tests
4. Push again

### Secrets Not Working
1. Verify secret name matches
2. Check secret is set in repository
3. Ensure correct syntax: `${{ secrets.SECRET_NAME }}`

## 📈 Best Practices

1. **Fast Feedback**: Keep CI fast (< 10 minutes)
2. **Fail Fast**: Run quick checks first (lint, format)
3. **Parallel Jobs**: Run independent jobs in parallel
4. **Cache Dependencies**: Cache Flutter SDK, packages
5. **Clear Names**: Use descriptive job/step names
6. **Artifacts**: Upload important builds
7. **Notifications**: Notify on failures (Slack, email)

## 🔐 Security

1. **Never commit secrets** - Use GitHub Secrets
2. **Limit permissions** - Use least privilege
3. **Review workflows** - Check before merging
4. **Use tokens** - Don't use personal tokens
5. **Rotate secrets** - Change regularly

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter CI/CD Best Practices](https://docs.flutter.dev/deployment/cd)
- [GitHub Actions Marketplace](https://github.com/marketplace?type=actions)

## 🎯 Next Steps

1. **Test the pipeline**: Push a commit and watch it run
2. **Add secrets**: Configure API keys, tokens
3. **Customize**: Adjust for your deployment needs
4. **Monitor**: Watch for failures and fix quickly
5. **Optimize**: Add caching, parallel jobs

---

**Remember**: CI/CD automates repetitive tasks, catches bugs early, and makes deployment reliable! 🚀

