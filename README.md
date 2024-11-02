docker-makepkg
==============


This docker image is intended to tests `PKGBUILDs`, by installing dependencies
and running `makepkg -f` in a clean Arch installation. It is intended to be
used by packagers, both via CI, and on non-ArchLinux environments.

The package can be saved to the current director by adding `-e EXPORT_PKG=1`,
and the updated .SRCINFO file for the built package with `-e EXPORT_SRCINFO=1`.

# v3 / v4

Depending, on which repository you want to build against, you choose simply between:
- docker-makepkg (generic)
- docker-makepkg-v3 (x86-64-v3 / avx2)
- docker-makepkg-v4 (x86-64-v4 / avx512)
- docker-makepkg-znver4 (Zen 4 Optimized)

# Usage



## Start to compile in the directory of the PKGBUILD
```
time docker run --name dockerbuilder -e EXPORT_PKG=1 -e SYNC_DATABASE=1 -v $PWD:/pkg cachyos/docker-makepkg && docker rm dockerbuilder
```

Replace the `cachyos/docker-makepkg` with the version you want to use, for example `cachyos/docker-makepkg-v3` to build for and against the x86-64-v3 repository.

Or export the updated .SRCINFO for the package

```
time docker run --name dockerbuilder -e EXPORT_PKG=1 -e SYNC_DATABASE=1 -e EXPORT_SRCINFO=1 -v $PWD:/pkg cachyos/docker-makepkg && docker rm dockerbuilder
```

## Build the image
```
docker build -t cachyos/docker-makepkg:latest .
```
