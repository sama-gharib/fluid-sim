# Fluid simulation in Fortran

This project is a very simple yet very satisfying fluid particle simulator.

## Dependencies

Please have the following installed :
- The gfortran compiler
- The `make` command
- The `git` command
- The [raylib C library](https://www.raylib.com/)

## Installation

```
$ git clone [git url here]
$ cd fluid-sim-master
$ make
```

## Troubleshooting

On Windows raylib requires additionnal linking flags when compiling. If compilation fails with a bunch of `Undefined reference` errors try adding the `-lopengl32 -lgdi32 -lwinmm` flags the the `gfortran` command in the Makefile. 