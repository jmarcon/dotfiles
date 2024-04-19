#!/bin/zsh

# get the ttimestamp from now 
timestamp=$(date +%Y%m%d%H%M%S)
dir="$(dirname $(dirname $(realpath $0)))"

echo $dir

# create a bkp from the original file (~/.zshrc), create a new backup every time
cp ~/.zshrc ~/.zshrc.$timestamp.bkp

# copy the .zshrc file from Config/zsh directory to home folder and overwrite the original file
echo "Copying the $dir/Config/zsh/.zshrc file to the home folder"
cp $dir/Config/zsh/.zshrc ~/.zshrc

# --- 
# create a bkp from the original folder (~/.dotfiles), create a new backup every time
cp -r ~/.dotfiles ~/.dotfiles.$timestamp.bkp

# remove the original folder
rm -rf ~/.dotfiles

# create the folder again
mkdir ~/.dotfiles


# create a symbolic link from the Config/zsh/.aliases file to the ~/.dotfiles folder
ln -s $dir/Config/zsh/.aliases.zsh ~/.dotfiles/.aliases.zsh
ln -s $dir/Config/zsh/.env.zsh ~/.dotfiles/.env.zsh
ln -s $dir/Config/zsh/.functions.zsh ~/.dotfiles/.functions.zsh
ln -s $dir/Config/zsh/.init.zsh ~/.dotfiles/.init.zsh
ln -s $dir/Config/zsh/.path.zsh ~/.dotfiles/.path.zsh

# create a symbolic link from the folder Config/zsh/aliases to the ~/.dotfiles folder

## Clean the symbolic links
# Verify if the symbolic link exists 
if [ -L ~/.dotfiles/aliases ]; then
  # remove the symbolic link
  echo "Removing the symbolic link ~/.dotfiles/aliases"
  rm ~/.dotfiles/aliases
fi

if [ -L ~/.dotfiles/env ]; then
  # remove the symbolic link
  echo "Removing the symbolic link ~/.dotfiles/env"
  rm ~/.dotfiles/env
fi

if [ -L ~/.dotfiles/functions ]; then
  # remove the symbolic link
  echo "Removing the symbolic link ~/.dotfiles/functions"
  rm ~/.dotfiles/functions
fi

if [ -L ~/.dotfiles/init ]; then
  # remove the symbolic link
  echo "Removing the symbolic link ~/.dotfiles/init"
  rm ~/.dotfiles/init
fi

if [ -L ~/.dotfiles/path ]; then
  # remove the symbolic link
  echo "Removing the symbolic link ~/.dotfiles/path"
  rm ~/.dotfiles/path
fi

# create the symbolic links
ln -s $dir/Config/zsh/aliases ~/.dotfiles/aliases
ln -s $dir/Config/zsh/env ~/.dotfiles/env
ln -s $dir/Config/zsh/functions ~/.dotfiles/functions
ln -s $dir/Config/zsh/init ~/.dotfiles/init
ln -s $dir/Config/zsh/path ~/.dotfiles/path



