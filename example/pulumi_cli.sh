#!/usr/bin/env bash
set -x

pulumi_bin=$(realpath '../_main~devbox_pkg~pulumi/bin/pulumi')

${pulumi_bin} --help

