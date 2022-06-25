#/bin/bash

cd ~/.homesick/repos/dotfiles_castle

git pull


brew install $(cat ~/.homesick/repos/dotfiles_castle/brew_formulae_list)
brew install $(cat ~/.homesick/repos/dotfiles_castle/brew_cask_list)

brew update; brew upgrade; brew cleanup

echo $(cat ~/.homesick/repos/dotfiles_castle/brew_formulae_list) $(brew list --formulae --full-name -1) | sed 's/ /\n/g' | sort -u > ~/.homesick/repos/dotfiles_castle/brew_formulae_list

echo $(cat ~/.homesick/repos/dotfiles_castle/brew_cask_list) $(brew list --casks --full-name -1) | sed 's/ /\n/g' | sort -u > ~/.homesick/repos/dotfiles_castle/brew_cask_list


git diff
