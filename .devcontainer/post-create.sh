#!/usr/bin/env bash

# ── Node Setup ───────────────────────────────────────────────
if [ -f package.json ]; then
  bash -i -c "nvm install --lts && nvm install-latest-npm"
  npm i
  npm run build
fi

# ── Shell Tools ──────────────────────────────────────────────
curl -sS https://webi.sh/shfmt | sh &>/dev/null

# ── Zsh Plugins ──────────────────────────────────────────────
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# Ensure plugins are added
sed -i -E "s/^(plugins=\()(git)(\))/\1\2 zsh-syntax-highlighting zsh-autosuggestions\3/" ~/.zshrc

# Avoid less in git log
echo -e "\nunset LESS" >>~/.zshrc

# ── Jekyll Setup ─────────────────────────────────────────────
# Ensure bundler is installed
gem install bundler

# Install project gems
bundle install

echo -e "\n✅ Post-create tasks done. Run \`bundle exec jekyll serve --livereload\` to preview your site."
