# Deploy to GH Pages with Travis-CI

This setup will deploy content from a `dist/` folder to GH-Pages via Travis-CI.

### Repository
Create or use one of your existing repositories on GitHub. Clone it, and create a `master` branch if you don't already have one. Use this branch for the rest of the setup.

### Initialize your project
In the root of your project, initialize with `npm init -f` to create a default `package.json` file if you don't already have one. Edit it, add the line marked with **bold** to generate dummy output in your `dist` folder:

<pre>
{
  "name": "test",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    <b>"build": "echo \"Hello, World\" > ./dist/index.html",</b>
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}
</pre>

### Deploy script
Create a folder in the root of your project called `scripts`. Inside it, add a file called `deploy-to-gh-pages.sh` containing this (replace the text marked with **bold**):

<pre>
#!/bin/bash
echo "Starting deployment"
echo "Target: gh-pages branch"

DIST_DIRECTORY="dist/"
CURRENT_COMMIT=`git rev-parse HEAD`
ORIGIN_URL=`git config --get remote.origin.url`
ORIGIN_URL_WITH_CREDENTIALS=${ORIGIN_URL/\/\/github.com/\/\/$GITHUB_TOKEN@github.com}

GH_USER_NAME="<b>lthr</b>"
GH_USER_EMAIL="<b>mikelothar@gmail.com</b>"

cp .gitignore $DIST_DIRECTORY || exit 1

echo "Checking out gh-pages branch"
git checkout -B gh-pages || exit 1

echo "Removing old static content"
git rm -rf . || exit 1

echo "Copying dist content to root"
cp -r $DIST_DIRECTORY/* . || exit 1
cp $DIST_DIRECTORY/.gitignore . || exit 1

echo "Pushing new content to $ORIGIN_URL"
git config user.name "$GH_USER_NAME" || exit 1
git config user.email "$GH_USER_EMAIL" || exit 1

git add -A . || exit 1
git commit --allow-empty -m "Regenerated static content for $CURRENT_COMMIT" || exit 1
git push --force --quiet "$ORIGIN_URL_WITH_CREDENTIALS" gh-pages > /dev/null 2>&1

echo "Cleaning up temp files"
rm -Rf $DIST_DIRECTORY

echo "Deployed successfully."
exit 0
</pre>


### Travis setup script
Create a file in the root of your project called `.travis.yml` containing this:

<pre>
language: node_js
node_js:
  - node
before_script:
  - chmod +x ./scripts/deploy-to-gh-pages.sh
script:
- npm run build
after_success:
  - ./scripts/deploy-to-gh-pages.sh
</pre>

### GitHub access token
Generate a new access token from [GitHub](https://github.com/settings/tokens/new). Give it a description, and the following permissions found [here](https://docs.travis-ci.com/user/github-oauth-scopes/). Don't close the window after you've created your token, you'll need the token later in this setup.

### Install Travis command line client
Install [Travis Command Line Client](https://github.com/travis-ci/travis.rb#readme) with `gem install travis`.

### Encrypt token
With the terminal, go into your project and execute the following (replace the text marked with **bold**):
<pre>
travis encrypt -r <b>YOUR-GITHUB-USERNAME-HERE</b>/<b>YOUR-GITHUB-REPOSITORY-NAME-HERE</b> GITHUB_TOKEN=<b>YOUR-GITHUB-TOKEN-HERE</b> --add
</pre>
This will add the encrypted token to your `.travis.yml` file.

### Travis-CI
Add your GitHub repository in your [Travis CI](https://travis-ci.org/profile) repository overview.

### GitHub repository settings
Go to your GitHub repository, under settings go to `Integration & Services`. Click the `Add service` dropdown and find `Travis CI`.

1. Under `User`, type your GitHub username.
2. Under `Token`, add your GitHub token.
3. Under Domain, type `notify.travis-ci.org`

### Add `dist/` folder
Create a folder in the root of your project called `dist`. Inside it, add a file called `index.html` containing some basic HTML. This is only for testing purpose, later you can add Gulp, Webpack or similar to generate your distribution content for this folder. Right now it's the `build` script from `package.js` that generates content in the `dist` folder.

### Create branch
In your GitHub repository, create a branch called `gh-pages`.

### Push your changes to GitHub
Now commit and push your changes to the `master` branch to GitHub. Travis-CI will detect this, and start deploying the content of the `dist` folder to GH-Pages. After deployment your page is available at <pre>http://<b>YOUR-GITHUB-USERNAME-HERE</b>.github.io/<b>YOUR-GITHUB-REPOSITORY-NAME-HERE</b></pre>.

