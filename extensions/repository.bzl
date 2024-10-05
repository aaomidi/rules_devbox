"""Defines the devbox_repo module extension.
"""

load("@rules_nixpkgs_core//:nixpkgs.bzl", "nixpkgs_http_repository", "nixpkgs_package")

# The primary implementation rule
def _devbox_repo_impl(module_ctx):
    lockfiles = []

    # TODO(@aaomidi): Q: Why do we loop over modules?
    for mod in module_ctx.modules:
        for tag in mod.tags.lockfile:
            lockfiles.append(module_ctx.read(tag.path))

    for lockfile in lockfiles:
        db = json.decode(lockfile)
        for key, value in db["packages"].items():
            resolved = value["resolved"]
            parts = resolved.split("#")
            target = parts[1]
            path_parts = parts[0].split("/")
            commit_hash = path_parts[-1]

            archive = "%s.tar.gz" % commit_hash
            strip_prefix = "nixpkgs-{}".format(commit_hash)
            url = "https://github.com/NixOS/nixpkgs/archive/%s" % (archive)
            nixpkgs_http_repository(
                name = target + "_nix_repo",
                url = url,
                strip_prefix = strip_prefix,
            )

_lockfile_tag = tag_class(
    attrs = {
        "path": attr.label(
            doc = "Target of the devbox.lock file",
            mandatory = True,
        ),
    },
    doc = "Import a package from devbox.",
)

devbox_repo = module_extension(
    implementation = _devbox_repo_impl,
    tag_classes = {
        "lockfile": _lockfile_tag,
    },
)
