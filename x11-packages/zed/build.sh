TERMUX_PKG_HOMEPAGE="https://zed.dev"
TERMUX_PKG_DESCRIPTION="A high-performance, multiplayer code editor from the creators of Atom and Tree-sitter"
TERMUX_PKG_LICENSE="AGPL-3.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.183.11"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/zed-industries/zed/archive/v${TERMUX_PKG_VERSION}/${TERMUX_PKG_VERSION}-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=2df19994ba6a34f16230ee2c4b7caf3429036bacccf163b261ad10ec36037c08
TERMUX_PKG_RECOMMENDS="clang"
TERMUX_PKG_SUGGESTS="clangd"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RM_AFTER_INSTALL="
opt/helix/runtime/grammars/sources/
"

termux_step_pre_configure() {
  termux_setup_rust

  # clash with rust host build
  unset CFLAGS
}

termux_step_make() {
  cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --release --frozen --package zed --package cli
}

termux_step_make_install() {
  #  local datadir="${TERMUX_PREFIX}/opt/${TERMUX_PKG_NAME}"
  #  mkdir -p "${datadir}"

  #  cat >"${TERMUX_PREFIX}/bin/hx" <<-EOF
  # #!${TERMUX_PREFIX}/bin/sh
  # HELIX_RUNTIME=${datadir}/runtime exec ${datadir}/hx "\$@"
  # EOF
  #  chmod 0700 "${TERMUX_PREFIX}/bin/hx"

  #  install -Dm700 target/"${CARGO_TARGET_NAME}"/release/cli "${datadir}/hx"

  #  cp -r ./runtime "${datadir}"
  # find "${datadir}"/runtime/grammars -type f -name "*.so" -exec chmod 0600 "{}" \;

  # install -Dm 0644 "contrib/completion/hx.zsh" "${TERMUX_PREFIX}/share/zsh/site-functions/_hx"
  # install -Dm 0644 "contrib/completion/hx.bash" "${TERMUX_PREFIX}/share/bash-completion/completions/hx"
  # install -Dm 0644 "contrib/completion/hx.fish" "${TERMUX_PREFIX}/share/fish/vendor_completions.d/hx.fish"
}
