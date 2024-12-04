function ll --wraps=ls --wraps='ls -altrh' --wraps='ls -Altrh --indicator-style=none' --description 'alias ll=ls -Altrh --indicator-style=none'
  ls -Altrh --indicator-style=none $argv
        
end
