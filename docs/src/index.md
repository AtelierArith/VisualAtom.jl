# VisualAtom

Documentation for [VisualAtom](https://github.com/AtelierArith/VisualAtom.jl).

⚠ This implementation is unofficial. ⚠

# Description

This repository contains [Julia](https://julialang.org/) implementation of [`visual_atomic_renderer/render_VisualAtom.py`](https://github.com/masora1030/CVPR2023-FDSL-on-VisualAtom/blob/47de71748abde6bd6568ee6e045ea23a047636da/visual_atomic_renderer/render_VisualAtom.py#L1-L130), originally implemented in Python. The original Python implementation can be found at [masora1030/CVPR2023-FDSL-on-VisualAtom](https://github.com/masora1030/CVPR2023-FDSL-on-VisualAtom)

# How to use

```console
$ git clone https://github.com/AtelierArith/VisualAtom.jl.git
$ cd VisualAtom.jl
$ make
$ docker compose run --rm shell julia --procs auto run.jl
```

That's it. You'll get `VisualAtom_dataset` directory within an hour.

```@raw html
<img width="860" alt="image" src="https://user-images.githubusercontent.com/16760547/235294665-b988f394-cc48-4bfe-ae7b-845af8cda9cd.png">
```

You can also use the following command:

```console
$ docker compose run --rm shell julia --threads auto run_mt.jl
```

See [README.md](https://github.com/AtelierArith/VisualAtom.jl/blob/main/README.md) to learn more.
