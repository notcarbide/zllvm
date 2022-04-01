#!/bin/sh

BRANCH=release/14.x

CLANGVAR=`$PWD/../zllvm-14/bin/clang --version | head -1 | cut -d ' ' -f6`
CLANGREF=${CLANGVAR%)}

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
  LLVMREF=`git rev-parse --short HEAD`
}

if [ ! -d llvm-project ]; then
  echo "Downloading LLVM Project source code..."
  git clone https://github.com/llvm/llvm-project -b $BRANCH
  cd llvm-project
else
  echo "Resetting LLVM Project source code to origin/$BRANCH..."
  reset_repo llvm-project
fi

echo "Generating a changelog between the current clang and updated LLVM source..."
echo "# Changelog\n## LLVM Changes:\n" > ../changes.txt
git log --oneline $CLANGREF^..$LLVMREF >> ../changes.txt
for change in `cat ../changes.txt | cut -d " " -f1`; do
	case "$change" in \#*) continue ;; esac
	sed -i "s,$change,[$change](https://github.com/llvm/llvm-project/commit/$change),g" \
		../changes.txt
done

echo "\nApplying patch(es)..."
git apply -v ../zap/patches/*.patch

exit
