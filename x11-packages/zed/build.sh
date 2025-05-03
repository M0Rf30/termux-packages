TERMUX_PKG_HOMEPAGE="https://zed.dev"
TERMUX_PKG_DESCRIPTION="A high-performance, multiplayer code editor from the creators of Atom and Tree-sitter"
TERMUX_PKG_LICENSE="AGPL-V3, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.184.8"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/zed-industries/zed/archive/v${TERMUX_PKG_VERSION}/${TERMUX_PKG_NAME}-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=ea84ff491b3a8cdf504c66e0d6504e8d6a62e83563ae1b051a65a0a6aeea8085
TERMUX_PKG_DEPENDS="fontconfig, libcurl, libsqlite, libxcb, libxkbcommon, libwayland, netcat-openbsd, openssl, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="protobuf, vulkan-headers, vulkan-loader-generic"
TERMUX_PKG_RECOMMENDS="clang"
TERMUX_PKG_SUGGESTS="clangd"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_pre_configure() {
	termux_setup_rust

	# clash with rust host build
	unset CFLAGS
	unset LDFLAGS

	cargo fetch --locked --target "$(rustc -vV | sed -n 's/host: //p')"
	export DO_STARTUP_NOTIFY="true"
	export APP_ICON="zed"
	export APP_NAME="Zed"
	export APP_CLI="zeditor"
	export APP_ID="dev.zed.Zed"
	export APP_ARGS="%U"
	envsubst < "crates/zed/resources/zed.desktop.in" > dev.zed.Zed.desktop
	./script/generate-licenses
}

termux_step_make() {
	CFLAGS+=' -ffat-lto-objects'
	CXXFLAGS+=' -ffat-lto-objects'
	RUSTFLAGS+=" --remap-path-prefix $PWD=/"
	export ZED_UPDATE_EXPLANATION='Updates are handled by pacman'
	export RELEASE_VERSION="$TERMUX_PKG_VERSION"
	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --release --frozen --package zed --package cli
}

termux_step_make_install() {
	install -Dm0755 target/release/cli "$TERMUX_PREFIX"/bin/zeditor
	install -Dm0755 target/release/zed "$TERMUX_PREFIX"/lib/"${TERMUX_PKG_NAME}"/zed-editor
	install -Dm0644 -t "$TERMUX_PREFIX"/share/applications/ dev.zed.Zed.desktop
	install -Dm0644 crates/zed/resources/app-icon.png "$TERMUX_PREFIX"/share/icons/"${TERMUX_PKG_NAME}".png
}
