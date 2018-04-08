# Deploy to GH Pages with Travis-CI

This setup will deploy content from a `dist/` folder to GH-Pages via Travis-CI.

### 1. Repository
Create or use one of your existing repositories on GitHub. Clone it, and create a `master` branch if you don't already have one. Use this branch for the rest of the setup.

### 2. Initialize your project
In the root of your project, initialize with `npm init -f` to create a default `package.json` file if you don't already have one. Edit it, add the line marked with **bold** to generate dummy output in your `dist` folder:

<pre>
{
  "name": "Deploy-to-GH-Pages",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    <b>"build": "mkdir ./dist && echo \"Deployed successfully!\" > ./dist/index.html",</b>
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}
</pre>

### 3. Deploy script
Create a folder in the root of your project called `scripts`. Inside it, add a file called `deploy-to-gh-pages.sh` containing this (replace the text marked with **bold**):

<pre>
#!/bin/bash
echo "Starting deployment"
echo "Target: gh-pages branch"

DIST_DIRECTORY="dist/"
CURRENT_COMMIT=`git rev-parse HEAD`
ORIGIN_URL=`git config --get remote.origin.url`
ORIGIN_URL_WITH_CREDENTIALS=${ORIGIN_URL/\/\/github.com/\/\/$GITHUB_TOKEN@github.com}

GH_USER_NAME="<b>mikelothar</b>"
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


### 4. Travis setup script
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

### 5. GitHub access token
Generate a new access token from [GitHub](https://github.com/settings/tokens/new). Give it a description, and the following permissions found [here](https://docs.travis-ci.com/user/github-oauth-scopes/):

![Github settings for deploying to TravisCI](https://i.imgur.com/susyCJ3.png)

Don't close the window after you've created your token, you'll need the token in step 8 and 9.

### 6. Travis-CI
Add your GitHub repository in your [Travis CI](https://travis-ci.org/profile) repository overview.

### 7. Install Travis command line client
Install [Travis Command Line Client](https://github.com/travis-ci/travis.rb#readme) with `gem install travis`.

### 8. Encrypt token
With the terminal, go into your project and execute the following (replace the text marked with **bold**):
<pre>
travis encrypt -r <b>YOUR-GITHUB-USERNAME</b>/<b>YOUR-GITHUB-REPOSITORY</b> GITHUB_TOKEN=<b>YOUR-GITHUB-TOKEN</b> --add
</pre>
This will add the encrypted token to your `.travis.yml` file.

### 9. GitHub repository settings
Go to your GitHub repository, under settings go to `Integration & Services`: 

![Github Integration and Services](https://i.imgur.com/B0Sho4F.png)

Click the `Edit` button and update with your GitHub username and the token you made in Step 5:

![Github Integration and Services](https://i.imgur.com/3WNeZTW.png)

### 10. Push your changes to GitHub
Now commit and push your changes to the `master` branch to GitHub. Travis-CI will detect this, and start deploying the content of the `dist` folder to GH-Pages. After deployment your page is available at <pre>http://<b>YOUR-GITHUB-USERNAME</b>.github.io/<b>YOUR-GITHUB-REPOSITORY</b></pre>, e.g. [http://mikelothar.github.io/Deploy-to-GH-Pages](http://mikelothar.github.io/Deploy-to-GH-Pages).

