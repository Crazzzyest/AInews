# Hosting the digest dashboard on Sliplane

The dashboard is a static site (`dashboard.html` + `archive.html` + `archive.json`)
served by nginx. Sliplane builds the `Dockerfile` in this folder from a Git repo
and runs the container.

## What's here
- `Dockerfile` — nginx:alpine serving the static files; listens on `$PORT` (default 80).
- `default.conf.template` — nginx config (serves `dashboard.html` at `/`, no-cache).
- `.dockerignore` — keeps build context lean.

## One-time setup

1. **Put this folder in a Git repo on GitHub** (Sliplane deploys from Git):
   ```sh
   cd C:\Users\edson\digests
   git init
   git add .
   git commit -m "Digest dashboard"
   git branch -M main
   git remote add origin https://github.com/<you>/<repo>.git
   git push -u origin main
   ```

2. **Create the service in Sliplane:**
   - New → Service → connect the GitHub repo + `main` branch.
   - Sliplane auto-detects the `Dockerfile`. Builder: Dockerfile.
   - **Port: `80`** (matches `EXPOSE 80` / default `$PORT`).
   - Deploy. Sliplane gives you an HTTPS URL.

   *(If you'd rather run on a different port, set a `PORT` env var in the
   service and set the service port to the same value — the container honors it.)*

## Updating after each digest run
The dashboard updates are just edits to `dashboard.html` (and the archive files).
After a `/digest` + `digest-dashboard` run:
```sh
git add dashboard.html archive.html archive.json
git commit -m "Digest YYYY-MM-DD"
git push
```
Sliplane redeploys automatically on push.

## Note — the page is public
The "request more sources" form opens a `mailto:` to
`edson.reistad@effektivaltruisme.no`, so that address (and all dashboard
content) is publicly visible once hosted. That's intended, but if you want the
address hidden, swap the form for a contact link behind something you control.
