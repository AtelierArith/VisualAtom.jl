# VisualAtom [![Build Status](https://github.com/AtelierArith/VisualAtom.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/AtelierArith/VisualAtom.jl/actions/workflows/CI.yml?query=branch%3Amain)

# Description

This repository contains [Julia](https://julialang.org/) implementation of [visual_atomic_renderer/render_VisualAtom.py](https://github.com/masora1030/CVPR2023-FDSL-on-VisualAtom/blob/47de71748abde6bd6568ee6e045ea23a047636da/visual_atomic_renderer/render_VisualAtom.py#L1-L130), originally implemented in Python. The original Python implementation can be found at https://github.com/masora1030/CVPR2023-FDSL-on-VisualAtom

# Getting Started

## Prerequisites

To use this Julia implementation, you will need:

- [Julia version](https://julialang.org/downloads/) ≥ 1.8

## Installation

1. Clone [this repository](https://github.com/AtelierArith/VisualAtom.jl):

```bash
$ git clone https://github.com/AtelierArith/VisualAtom.jl.git
```

2. Change directory into the repository:

```bash
$ cd VisualAtom.jl
```

3. Install the required Julia packages:

```console
$ julia --project=@. -e 'import Pkg; Pkg.instantiate()'
  Activating project at `~/work/atelier_arith/VisualAtom.jl`
Precompiling project...
  Progress [>                                        ]  0/1
  ◓ VisualAtom
```

## Usage

⚠️ Make sure you have enough storage space (200GB).⚠️

Easy! Just run:

```console
$ julia --project=@. --procs auto run.jl
```

1000 * 1000 images will be generated. The program ran on a 2019 iMac.

<img src="https://user-images.githubusercontent.com/16760547/235292892-d0dcc052-d0c3-45c4-bc83-40fa708847d5.png">

If you are surprised by these results, you may want to consider moving from Python to Julia.

### Tips

> `--procs {N|auto}`
>  Integer value N launches N additional local worker processes
>  "auto" launches as many workers as the number of local CPU threads (logical cores)

### Another easy shortcut

Having trouble installing Julia? You can save yourself the trouble of installation by using a Docker container.

```console
$ make && docker compose run --rm shell julia -p auto run.jl
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- The original Python implementation: https://github.com/masora1030/CVPR2023-FDSL-on-VisualAtom
- The authors of the CVPR 2023 paper for their novel work on the FDSL algorithm
