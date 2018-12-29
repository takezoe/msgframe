#!/bin/bash
set -e

if [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_BRANCH" == "master" -o "$TRAVIS_BRANCH" == "$TRAVIS_TAG" ]; then
  PUBLIC_IP=$(curl https://api.ipify.org)
  echo "Public IP Address of this machine: ${PUBLIC_IP}"
  tar xvf travis/secrets.tar
  if [ -z "$TRAVIS_TAG" ]; then
     # Publish a snapshot
     ./sbt "+ projectJVM/publish"
  else
     # Publish a release version
     RELEASE=true ./sbt "; + projectJVM/publishSigned; sonatypeReleaseAll"
  fi
else
  echo "This not a master branch commit. Skipping the release step"
fi