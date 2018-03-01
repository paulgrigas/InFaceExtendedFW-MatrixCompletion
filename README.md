# InFaceExtendedFW-MatrixCompletion

Code associated with the [paper](http://epubs.siam.org/doi/abs/10.1137/15M104726X):

> *An Extended Frank-Wolfe Method with “In-Face” Directions, and its Application to Low-Rank Matrix Completion*, by Robert M. Freund, Paul Grigas, and Rahul Mazumder, SIAM Journal on Optimization 27 (1), pp. 319-346, 2017.

## Overview

The code is divided into two folders:
- `solver` contains all of the files needed to run the method.
- `experiments` contains files concerning the experiments in the paper.

Before anything else be sure to install the mex file:
```
mex project_obs_UV.c
```

The main file in the `solver` folder for running the In-Face Extended Frank-Wolfe Method is `InFace_Extended_FW_sparse.m`. The syntax for calling this function is:
```
[Zk, history, dynamic_info] = InFace_Extended_FW_sparse(mat_comp_instance, alt_fun, update_representation, options, start_params)
```
The file `InFace_Extended_FW_sparse.m` contains documentation describing the various arguments and outputs to this function. As noted in the file, this function requires inputting a handle to a function `alt_fun` for computing the alternative direction and a handle to a function `update_representation` for updating the iterate representation (either an SVD or an overcomplete basis) after moving in a direction. We have provided several implementations for these functions, as described below.

Implementations for `update_representation`:
- `update_svd` assumes that the representation is a (thin) SVD, and is what one should use for our proposed method.
- `update_overcomplete` assumes that the representation is the overcomplete basis of FW atoms, and is what one should use for the atomic and fully corrective methods.

Implementations for `alt_fun`:
- `Away_step_standard_sparse` is the standard away-step direction, and should be used with `update_svd`.
- `prox_grad_face` is the full optimization strategy in the current face using a simple prox gradient scheme, and should be used with `update_svd`.
- `Inface_FW_sparse` is a normal Frank-Wolfe direction restricted to within the current face, and should be used with `update_svd`.
- `Away_step_simplex_sparse` is the standard away-step direction in the unit simplex, and should be used with `update_overcomplete`.
- `prox_grad_simplex` is the full optimization strategy in the unit simplex using a simple prox gradient scheme, and should be used with `update_overcomplete`.


Most of the time, the `start_params` argument is not used. In the experiments folder, see the files `generate_table_instance.m` and `run_algs_table.m` to see examples of how the method is called.
