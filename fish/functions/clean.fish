function clean --description 'alias clean=sudo apt autoremove && sudo apt autoclean && sudo apt autopurge && sudo apt clean'
  sudo apt autoremove && sudo apt autoclean && sudo apt autopurge && sudo apt clean $argv
        
end
