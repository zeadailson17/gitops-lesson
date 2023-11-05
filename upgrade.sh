#!/bin/bash

# exit when any command fails
set -e

new_ver=$1

echo "new version: $new_ver"

# Simulate release of the new docker images
docker tag nginx:1.25.3 zeadailson/ze-gitops-lesson:$new_ver

# Push new version to dockerhub
docker push zeadailson/ze-gitops-lesson:$new_ver

# Create temporary folder
tmp_dir=$(mktemp -d)
echo $tmp_dir

# Clone GitHub repo
git clone git@github.com:zeadailson17/gitops-lesson.git $tmp_dir

# Update image tag
sed -i '' -e "s/zeadailson\/ze-gitops-lesson:.*/zeadailson\/ze-gitops-lesson:$new_ver/g" $tmp_dir/my-app/1-deployment.yaml

# Commit and push
cd $tmp_dir
git add .
git commit -m "Update image to $new_ver"
git push

# Optionally on build agents - remove folder
rm -rf $tmp_dir