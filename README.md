# Multiarch Containers

This repository hosts containers based on Arch Linux that come pre-installed with various packages, including `docker`, `kubeconform`, `dovecot`, `postfix`, and more. These containers are designed for multiarch compatibility, thanks to the Arch Linux ARM project.

## Container Tags

The tags follow the format of official dockerhub images. Versions follow the package version of the archlinux package:

* 1.28.2-1
* 1.28.2
* 1.28
* 1
* latest

None of them are guarranteed to be immutable as images are rebuilt with the latest base and librariries. If you need immutability, pin by sha256.
