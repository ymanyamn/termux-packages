TERMUX_PKG_HOMEPAGE=https://nghttp2.org/ngtcp2/
TERMUX_PKG_DESCRIPTION="An effort to implement IETF QUIC protocol"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.0"
TERMUX_PKG_SRCURL=https://github.com/ngtcp2/ngtcp2/releases/download/v${TERMUX_PKG_VERSION}/ngtcp2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=803eeb4a626d37a7512eacd6f419dbc4bb8ddbc1e105310c0fe9c322b4a1f7de
TERMUX_PKG_DEPENDS="libgnutls, libnghttp3"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-gnutls"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=16

	local a
	for a in LT_CURRENT LT_AGE; do
		local _${a}=$(sed -En 's/^AC_SUBST\('"${a}"',\s*([0-9]+).*/\1/p' \
				configure.ac)
	done
	local v=$(( _LT_CURRENT - _LT_AGE ))
	if [ ! "${_LT_CURRENT}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	autoreconf -fi
}
