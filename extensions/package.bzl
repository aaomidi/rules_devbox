"""Defines the devbox_pkg module extension.
"""

load("@rules_nixpkgs_core//:nixpkgs.bzl", "nixpkgs_http_repository", "nixpkgs_package")

# The primary implementation rule
def _devbox_pkg_impl(module_ctx):
    for mod in module_ctx.modules:
        for tag in mod.tags.pkg:
            nixpkgs_package(
                name = tag.pkg,
                attribute_path = tag.pkg,
                repository = "@" + tag.pkg + "_nix_repo",
                nix_file_deps = ["@" + tag.pkg + "_nix_repo"],
            )

_pkg_tag = tag_class(
    attrs = {
        "pkg": attr.string(
            doc = "A unique name for this repository",
            mandatory = True,
        ),
    },
    doc = "Import a package from devbox.",
)

devbox_pkg = module_extension(
    implementation = _devbox_pkg_impl,
    tag_classes = {
        "pkg": _pkg_tag,
    },
)
