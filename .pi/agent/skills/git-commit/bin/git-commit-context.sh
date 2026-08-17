#!/usr/bin/env bash

set -x

git status
git log --oneline -10
git diff --staged --stat
git diff --staged
