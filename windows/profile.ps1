# set emacs mode command line hotkey
# install psreadline first by "Install-Module -Name PSReadLine -AllowClobber -Force"
Set-PSReadLineOption -EditMode Emacs

# starship prompt; config at ~\.config\starship.toml, linked by
# windows-setup.ps1. Without starship, PowerShell keeps its default prompt.
Import-Module posh-git
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

function enProxy {
	[Environment]::SetEnvironmentVariable("http_proxy", "http://127.0.0.1:8889", "User")
	[Environment]::SetEnvironmentVariable("https_proxy", "http://127.0.0.1:8889", "User")
}

function deProxy {
	[Environment]::SetEnvironmentVariable("http_proxy", $null, "User")
	[Environment]::SetEnvironmentVariable("https_proxy", $null, "User")
}
