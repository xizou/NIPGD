# NIPGD
An example code of NIPGD scheme.

## Requirements

To run this code, you need have [Matlab](https://uk.mathworks.com/products/matlab/) installed on your system. MS Windows, Mac OS X and Unix/Linux are all supported.

To run this code with the non-intrusive option, you need the installation of both Matlab and [Abaqus](http://www.3ds.com/products-services/simulia/products/abaqus/). In this case, Mac OS X is not supported.

The code is tested on:

- Matlab 2012b, 2015b, 2016a.
- Abaqus/Standard 6.11-1, 6.13-4, 2016.

## Problem overview

#### The model

A curved beam made of two linear elastic materials with the same Poisson's ratio but different Young's modulus $E_1$ and $E_2$, fixed at the lower end and loaded at the upper end.

The model is discretized with finite elements, model data is contained in the Abaqus input file `model.inp`. Users may replace this file with any similar model as long as the input file follows these convention:

- The node set `nSet-Load` contains the loaded nodes.
- The node set `nSet-Fixed` contains the fixed (pinned) nodes.
- The element set `elSet-1` contains elements with Young's modulus $E_1$.
- The element set `elSet-2` contains elements with Young's modulus $E_2$.

We will take displacement of Node 100 for example in post-processing.

![Model](https://raw.githubusercontent.com/xizou/NIPGD/master/image/model.png)

#### Running environment

File `abaqus_v6.env` sets up the necessary environment variables for Abaqus.

## Usage

The range for $E_1$ and $E_2$ can be specified in `main.m`.

By default, non-intrusive option is deactivated, so that you may run it without Abaqus. If you want to run non-intrusively, set variable `non_intrusive=1` in `main.m`.

You may run the main file in both in Matlab interface or in terminal.

- In Matlab interface: `>>main`
- In terminal: `$ matlab -nodisplay -nojvm << main.m`

## Result and post-processing

You should obtain `vademecum.mat` after running the code.

Goto folder `post` and run Matlab file `online_plot.m` for post-processing.

Displacement components for Node 100:

![Model](https://raw.githubusercontent.com/xizou/NIPGD/master/image/result.png)