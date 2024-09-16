"""Defines the devbox_pkg module extension.
"""

# The primary implementation rule
def _devbox_pkg_impl(module_ctx):
    pass

_pkg_tag = tag_class(
)

def _pkg_impl(attrs):
    # TODO(@aaomidi): Q: This is where I imagine I need to somehow call rules_nixpkg for setting up the repo && package.
    pass

devbox_pkg = module_extension(
    implementation = _devbox_pkg_impl,
    tag_classes = {
        "pkg": _pkg_tag,
    },
)
