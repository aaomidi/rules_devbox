"""Defines the devbox_repo module extension.
"""

load("@rules_nixpkgs_core//:nixpkgs.bzl", "nixpkgs_http_repository")

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
            print(target)

    # So, I probably don't want to setup an actual repository here for
    # every single package in the lockfile, right?
    # If I do, does that mean all those repositories are going to be
    # Fetched for every single bazel file?

    # There may be many more packages in the lockfile than what
    # we're going to end up using in bazel.
    # Should we actually do most of the work in the _devbox_pkg rule?
    # Does it even make sense to define a separate repo vs pkg rule?

    # TODO(@aaomidi): Q: What am I actually supposed to do here?
    # In this phase, I don't know anything about the user's devbox setup.
    # I want to use the user's devbox.lock file to figure out the nix repos I need to use
    pass

_lockfile_tag = tag_class(
    attrs = {
        "name": attr.string(
            doc = "A unique name for this repository",
            mandatory = True,
        ),
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
