function clean --description 'alias clean=sudo apt autoremove && sudo apt autoclean && sudo apt clean'
  sudo apt autoremove && sudo apt autoclean && sudo apt clean $argv
        
end
