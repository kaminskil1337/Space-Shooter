#!/bin/bash

git checkout heroku
git merge main
git rm -rf SpaceShooter
git rm -rf README
git rm -rf README.md
git rm -rf .gitignore
git rm -rf deploy.bash
git mv Leaderboard/* ./.
git rm -rf Leaderboard
git add .
git commit -m "heroku commit"
git push
git checkout main