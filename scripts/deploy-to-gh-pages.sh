#!/bin/bash
rm -rf out || exit 0;
mkdir out;
#node build.js
( cd out
 git init
 git config user.name "lthr"
 git config user.email "mikelothar@gmail.com"
 cp ../hello.js ./hello.js
 git add .
 git commit -m "Deployed to Github Pages"
 # git push --force --quiet "https://${GITHUB_TOKEN}@${GH_REF}" master:gh-pages > /dev/null 2>&1
 git push --force "https://${GITHUB_TOKEN}@${GH_REF}" master:gh-pages
)