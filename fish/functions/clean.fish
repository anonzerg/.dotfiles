function clean --wraps='sudo dnf clean all && sudo dnf autoremove' --description 'alias clean=sudo dnf clean all && sudo dnf autoremove'
  sudo dnf clean all && sudo dnf autoremove $argv
        
end
