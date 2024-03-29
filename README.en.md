Versatile TRNG IP Core for Evaluation on PYNQ Platform
======================================================

Abstract
--------

This repository contains a versatile TRNG IP core, designed to evaluate
various true random number generator circuits on the PYNQ platform.

The repository is organized as follows:

- `core`: TRNG IP core folder (`xgui` folder and `component.xml` file will be generated by Vivado)
  - `src`: HDL description of the controller, written in Verilog HDL and SystemVerilog
    - `user`: prototype of user defined TRNG circuit
- `python`: examples of Python script to collect random bitstrings
- `samples`: samples of user defined TRNG circuit
  - `TC-TERO`: a TRNG based on <a href="https://github.com/nfproc/TC-TERO">transition effect ring oscillator (TERO)</a>
  - `latch`: a TRNG based on <a href="https://doi.org/10.1587/elex.15.20180386">the metastability of RS latch</a>
  - `C_COSO`: a TRNG based on <a href="https://doi.org/10.1109/FPL.2019.00041">coherent sampling with configurable ring oscillators (Configurable COSO)</a>
    - Re-implemented by the author of the repository. A controller for auto calibration, presented in the reference, is not included.
    - You can find the original source code at <a href="https://github.com/KULeuven-COSIC/COSO-TRNG">KULeuven-COSIC/COSO-TRNG</a>
- `docs`: specification and use cases of the core

The core is designed so that random bitstrings can be collected on the PYNQ
platform (v2.7). The author synthesized a PYNQ overlay with the core using
Vivado 2020.2, targetting the PYNQ-Z1 board.

More information about developing an overlay and collecting bitstrings is
found in <a href="https://www.acri.c.titech.ac.jp/wordpress/archives/11585">
an article of the ACRi blog</a> (in Japanese).

Copyright
---------

The all files in this repository, written in Verilog HDL, SystemVerilog,
or Python, are developped by <a href="https://aitech.ac.jp/~dslab/nf/index.en.html">Naoki FUJIEDA</a>.
They are licensed under the New BSD license.
See the COPYING file for more information.

Copyright (C) 2018-2022 Naoki FUJIEDA. All rights reserved.