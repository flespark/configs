# set emacs mode command line hotkey
# install psreadline first by "Install-Module -Name PSReadLine -AllowClobber -Force"
Set-PSReadLineOption -EditMode Emacs

# enable oh-my-posh (powerline prompt)
Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme space

function enProxy {
	[Environment]::SetEnvironmentVariable("http_proxy", "http://127.0.0.1:8889", "User")
	[Environment]::SetEnvironmentVariable("https_proxy", "http://127.0.0.1:8889", "User")
}

function deProxy {
	[Environment]::SetEnvironmentVariable("http_proxy", $null, "User")
	[Environment]::SetEnvironmentVariable("https_proxy", $null, "User")
}
