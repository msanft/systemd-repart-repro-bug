# systemd-repart Reproducibility Bug Reproducer

This repository contains a minimal reproducing example for a reproducibility bug of systemd-repart, where directories in the temporary tree will have an undeterministic atime/mtime (current time).

To reproduce:

```bash
touch -amt 197001010000 os-tree/somefile
./bug.sh
```

This will invoke systemd-repart with the OS tree at `os-tree`, while hooking `hook/mkfs.ext4` into the path to get an easy entrypoint for at-runtime inspection of the temporary directory created by systemd-repart.
It will show that the timestamps of `os-tree/somefile` are persistent when being copied into the image at `/somedir/somefile`, **but the directory that needs to be created in the local tree (`/somedir`) has an undeterministic atime/mtime**, even though systemd-repart is invoked with []`SOURCE_DATE_EPOCH`](https://reproducible-builds.org/docs/source-date-epoch/), which is a problem for reproducibility.

Most likely, this is due to the use of [`xopenat_lock_full` with `O_CREAT`](https://github.com/systemd/systemd/blob/1eeae735ad3d42d60f6513dea6d9ab0d2d858e82/src/shared/copy.c#L1020) when [populating the temporary local tree](https://github.com/systemd/systemd/blob/1eeae735ad3d42d60f6513dea6d9ab0d2d858e82/src/partition/repart.c#L4859).
