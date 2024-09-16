"""Defines the devbox_repo module extension.
"""

# The primary implementation rule
def _devbox_repo_impl(module_ctx):
    lockfiles = []

    # TODO(@aaomidi): Q: Why do we loop over modules?
    for mod in module_ctx.modules:
        for tag in mod.tags.lockfile:
            lockfiles.append("Well, that was a lockfile indeed.")
    print(lockfiles)

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

def _lockfile_tag_impl(lockfile_tag_input):
    # Get the path of the lockfile
    #somecode

    # Parse that through //cmd/devbox_parser -- --path=/path/to/file
    #somecode

    # IDK more??
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
        "lockfile": _lockfile_tag,  # TODO(@aaomidi): Q: Where does the implementation for this actually live? Can I call a go binary here?
    },
)
