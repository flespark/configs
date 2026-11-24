. "$HOME/.cargo/env"

# basic
export EDITOR=nvim
export PAGER=less

# uv
export PATH="/Users/simon/.local/bin:$PATH"

# cache
export PATH="/opt/homebrew/opt/ccache/libexec:${PATH}"

# flutter
export PATH="/Users/simon/flutter/bin:${PATH}"

# texinfo
export PATH="/opt/homebrew/opt/texinfo/bin:${PATH}"

# homebrew (走 GitHub 官方源，配合 TUN 代理；aliyun 镜像 brew.git 数据不完整已弃用)
# export HOMEBREW_API_DOMAIN="https://mirrors.aliyun.com/homebrew-bottles/api"
# export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/brew.git"
# export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/homebrew-core.git"
# export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles"

# 运行 brew 不自动检查更新
export HOMEBREW_NO_AUTO_UPDATE=1
# 每次运行 brew install 或 brew upgrade 后，自动执行 cleanup 清理垃圾
export HOMEBREW_NO_INSTALL_CLEANUP=1

# jave sdk
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH=$JAVA_HOME/bin:$PATH

# android sdk
export ANDROID_HOME=/opt/homebrew/share/android-commandlinetools

export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools


