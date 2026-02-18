# Coin Collecting Web Tool

This project is a static web page that can be hosted free on GitHub Pages.

## Files used for hosting

- `index.html` (main public page)

## Publish to GitHub Pages (Windows)

Open PowerShell in this folder and run:

```powershell
git init
git add index.html README.md
git commit -m "Initial public site"
git branch -M main
git remote add origin https://github.com/<your-username>/<repo-name>.git
git push -u origin main
```

Then in GitHub:

1. Open your repository.
2. Go to **Settings** → **Pages**.
3. Under **Build and deployment**, choose:
   - **Source**: Deploy from a branch
   - **Branch**: `main`
   - **Folder**: `/ (root)`
4. Click **Save**.

## Live URL

Your site will be available at:

`https://<your-username>.github.io/<repo-name>/`

It can take 1–3 minutes after first publish.
