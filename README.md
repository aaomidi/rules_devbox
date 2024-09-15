# Bazel rules for devbox

## Installation

From the release you wish to use:
<https://github.com/aaomidi/rules_devbox/releases>
copy the WORKSPACE snippet into your `WORKSPACE` file.

To use a commit rather than a release, you can point at any SHA of the repo.

For example to use commit `abc123`:

1. Replace `url = "https://github.com/aaomidi/rules_devbox/releases/download/v0.1.0/rules_devbox-v0.1.0.tar.gz"` with a GitHub-provided source archive like `url = "https://github.com/aaomidi/rules_devbox/archive/abc123.tar.gz"`
1. Replace `strip_prefix = "rules_devbox-0.1.0"` with `strip_prefix = "rules_devbox-abc123"`
1. Update the `sha256`. The easiest way to do this is to comment out the line, then Bazel will
   print a message with the correct value. Note that GitHub source archives don't have a strong
   guarantee on the sha256 stability, see
   <https://github.blog/2023-02-21-update-on-the-future-stability-of-source-code-archives-and-hashes/>
