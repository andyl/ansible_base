# VsCode

Microsoft is unusual in that they prepare deb package installers, but they only
allow you to download the most recent version of the code.

We like to be able to install old versions, to keep all development machines in
sync.

So we have to keep old versions of debian packages around.  Yukk.  We don't
want to put the debian packages here in the Ansible roles repo because they are
too large, so we keep them in offline storage optimized for large binaries.

We store the old version in ~/var/data/vscode.  There is a script
"GetCurrentVersion" to pull down the current package.
