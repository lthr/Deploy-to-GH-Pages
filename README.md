# Deploy to GH Pages


1. Generate an access token from [GitHub](https://github.com/settings/tokens) (keep it, you'll need it twice)
2. Copy the `.travis.yml` file to your project
3. Terminal into your project, execute `travis encrypt -r lthr/X GITHUB_TOKEN=insert-token-key-here --add` with your token
4. Add your GitHub repository in [Travis CI](https://travis-ci.org)
5. In your GitHub repository settings, go to `Integration & Services`, `add Travis CI`, use your GitHub login, your token, and under Domain, put this: `notify.travis-ci.org`
6. Copy the `/scripts/deploy-to-gh-pages.sh` to your repository
7. Make sure you have a package.json file in your repository (create one with `npm init`)
8. Create a branch in your GitHub repository called `gh-pages`
9 Add Gulp or similar to build your content and place it in `dist/` folder
