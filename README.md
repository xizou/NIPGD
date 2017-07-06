# NIPGD
An example code of Non-Intrusive Proper Generalized Decomposition (NIPGD) scheme. PGD is one of the approaches for model order reduction. See [Chinesta 2013](http://doi.org/10.1007/s11831-013-9080-x).

[![lic](https://img.shields.io/badge/license-GPL%20v3-blue.svg)](https://github.com/xizou/NIPGD/blob/master/LICENSE)
[![matlab](https://img.shields.io/badge/MATLAB-R2017a-green.svg)](https://www.mathworks.com/products/matlab/)
[![abaqus](https://img.shields.io/badge/Abaqus-2016-green.svg)](http://www.3ds.com/products-services/simulia/products/abaqus/)

## Requirements

To run this code, you need have [MATLAB](https://www.mathworks.com/products/matlab/) installed on your system. MS Windows, Mac OS X and Unix/Linux are all supported.

To run this code with the non-intrusive option, you need the installation of both MATLAB and [Abaqus](http://www.3ds.com/products-services/simulia/products/abaqus/). In this case, Mac OS X is not supported.

The code is tested on:

- MATLAB 2012b, 2015b, 2016a.
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

You may run the main file in both in MATLAB interface or in terminal.

- In Matlab interface:
  ```matlab
  >> main
  ```
- In terminal:
  ```shell
  $ matlab -nodisplay -nojvm << main.m
  ```

## Result and post-processing

You should obtain `vademecum.mat` after running the code.

Goto folder `post` and run MATLAB file `online_plot.m` for post-processing:

```matlab
>> cd post
>> online_plot.m
```



Displacement components for Node 100:

![Model](https://raw.githubusercontent.com/xizou/NIPGD/master/image/result.png)

## License and citation

This code is distributed under GNU General Public License v3.0.

- Permissions of this strong copyleft license are conditioned on making available complete source code of licensed works and modifications, which include larger works using a licensed work, under the same license. Copyright and license notices must be preserved. Contributors provide an express grant of patent rights.

If you find it useful for your work, please cite as follows:

- Zou, X., Conti, M., Diez, P., & Auricchio, F. (2017). A non-intrusive proper generalized decomposition scheme with application in biomechanics. *International Journal for Numerical Methods in Engineering*. http://doi.org/10.1002/nme.5610
