# set emacs mode command line hotkey
Set-PSReadLineOption -EditMode Emacs

# enable oh-my-posh (powerline prompt)
Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme space
