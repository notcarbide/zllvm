#!/bin/sh

BRANCH=release/14.x

reset_repo ()
{
  cd $PWD/$1
  git clean -qfd
  git checkout .
  git remote update > /dev/null
  git reset --hard origin/$BRANCH > /dev/null
  git clean -qfd
  git checkout $BRANCH > /dev/null
  git pull
}

if [ ! -d llvm-project ]; then
  echo "Downloading LLVM Project source code..."
  git clone https://github.com/llvm/llvm-project -b $BRANCH
else
  echo "Resetting LLVM Project source code to origin/$BRANCH..."
  reset_repo llvm-project
fi

echo "\nApplying patch(es)..."
git apply -v ../zap/patches/*.patch

exit
