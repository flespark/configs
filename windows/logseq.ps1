# based off windows-setup.ps1
scoop bucket add scoop-clojure https://github.com/littleli/scoop-clojure

scoop install \
    nodejs \
    yarn \
    adoptopenjdk-lts-hotspot \
    clojure

# config proxy, refer to https://www.jhipster.tech/configuring-a-corporate-proxy/
npm config set proxy http://127.0.0.1:8889
npm config set https-proxy http://127.0.0.1:8889
yarn config set proxy http://127.0.0.1:8889
yarn config set https-proxy http://127.0.0.1:8889

# config npm inland mirrors
npm config set registry https://registry.npm.taobao.org/
npm config set ELECTRON_MIRROR http://npm.taobao.org/mirrors/electron/

cd d:\Download
git clone https://github.com/logseq/logseq
cd logseq
yarn
# if response clojure not find, change the package.json
# use cmd-clj instead of clojure in scripts block
yarn watch

# open http://localhost:3001
yarn release
