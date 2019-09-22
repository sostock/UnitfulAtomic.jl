# UnitfulAtomic

This package extends the [Unitful.jl](https://github.com/PainterQubits/Unitful.jl)
package to facilitate working with [atomic units](https://en.wikipedia.org/wiki/Atomic_units).

[![Build Status](https://travis-ci.com/sostock/UnitfulAtomic.jl.svg?branch=master)](https://travis-ci.com/sostock/UnitfulAtomic.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/v162jvq76dwifxdx/branch/master?svg=true)](https://ci.appveyor.com/project/sostock/unitfulatomic-jl/branch/master)
[![codecov](https://codecov.io/gh/sostock/UnitfulAtomic.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/sostock/UnitfulAtomic.jl)
[![Coverage Status](https://coveralls.io/repos/github/sostock/UnitfulAtomic.jl/badge.svg?branch=master)](https://coveralls.io/github/sostock/UnitfulAtomic.jl?branch=master)

## Functions

This package provides three functions that enable easy conversion from and to Hartree atomic
units:

* `aunit(x)` returns the appropriate atomic unit for `x`, where `x` can be a
  `Unitful.Quantity`, `Unitful.Units`, or `Unitful.Dimensions`:
  ```julia
  julia> aunit(2.3u"cm")
  a₀

  julia> aunit(u"T")
  a₀^-2 e^-1 ħ
  ```
* `auconvert` can be used to convert from and to atomic units. It has two methods:
  * `auconvert(x::Unitful.Quantity)` converts a quantity to the appropriate atomic unit:
    ```julia
    julia> auconvert(13.6u"eV")
    0.4997907858599377 Eₕ

    julia> auconvert(20u"nm")
    377.94522509156565 a₀
    ```
  * `auconvert(u::Unitful.Units, x::Number)` interprets `x` as a quantity in atomic units
    and converts it to the unit `u`:
    ```julia
    julia> auconvert(u"eV", 1)  # convert 1 Eₕ to eV
    27.211386013449417 eV

    julia> auconvert(u"m", 1)   # convert 1 a₀ to m
    5.2917721067e-11 m
    ```
* `austrip(x::Unitful.Quantity)` converts a quantity to the appropriate atomic unit and then
  strips the units. This is equivalent to `Unitful.ustrip(auconvert(x))`:
  ```julia
  julia> austrip(13.6u"eV")
  0.4997907858599377

  julia> austrip(20u"nm")
  377.94522509156565
  ```

## Defined units

The package defines the following atomic units (suffixed with `_au`), from which all other
atomic units are derived:

* `me_au` (printed as `mₑ`): the
  [electron rest mass](https://en.wikipedia.org/wiki/Electron_rest_mass).
* `e_au` (printed as `e`): the
  [elementary charge](https://en.wikipedia.org/wiki/Elementary_charge).
* `ħ_au` (printed as `ħ`): the
  [reduced Planck constant](https://en.wikipedia.org/wiki/Planck_constant).
* `k_au` (printed as `k`): the
  [Boltzmann constant](https://en.wikipedia.org/wiki/Boltzmann_constant).
* `a0_au` (printed as `a₀`): the [Bohr radius](https://en.wikipedia.org/wiki/Bohr_radius).
  The alias `bohr` can be used instead of `a0_au`.
* `Eh_au` (printed as `Eₕ`): the [Hartree energy](https://en.wikipedia.org/wiki/Hartree).
  The alias `hartree` can be used instead of `Eh_au`.

Furthermore, this package defines some units that are not atomic units, but are common in
atomic physics:

* `Ry`: the Rydberg energy `Ry = h*c*R∞ = Eₕ/2`, see
  [Rydberg constant](https://en.wikipedia.org/wiki/Rydberg_constant).
* `μ_N`: the [nuclear magneton](https://en.wikipedia.org/wiki/Nuclear_magneton).
* `angstrom`: see [angstrom](https://en.wikipedia.org/wiki/Angstrom).
