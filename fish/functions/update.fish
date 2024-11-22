function update --wraps='sudo apt update && sudo apt upgrade -y' --description 'alias update=sudo apt update && sudo apt upgrade -y'
  sudo apt update && sudo apt upgrade -y $argv
        
end
