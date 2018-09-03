# UnitfulAtomic

This package extends [Julia](https://julialang.org)’s
[Unitful.jl](https://github.com/ajkeller34/Unitful.jl) package to facilitate working with
[atomic units](https://en.wikipedia.org/wiki/Atomic_units).

[![Build Status](https://travis-ci.com/sostock/UnitfulAtomic.jl.svg?branch=master)](https://travis-ci.com/sostock/UnitfulAtomic.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/v162jvq76dwifxdx/branch/master?svg=true)](https://ci.appveyor.com/project/sostock/unitfulatomic-jl/branch/master)

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
  strips the units. This is equivalent to `ustrip(auconvert(x))`:
  ```julia
  julia> austrip(13.6u"eV")
  0.4997907858599377
  
  julia> austrip(20u"nm")
  377.94522509156565
  ```

## Defined units and dimensions

The package defines the following atomic units, from which all other atomic units are
derived:

* `mₑ`: the [electron rest mass](https://en.wikipedia.org/wiki/Electron_rest_mass).
* `e`: the [elementary charge](https://en.wikipedia.org/wiki/Elementary_charge)
* `ħ`: the [reduced Planck constant](https://en.wikipedia.org/wiki/Planck_constant)
* `k`: the [Boltzmann constant](https://en.wikipedia.org/wiki/Boltzmann_constant)
* `a₀`: the [Bohr radius](https://en.wikipedia.org/wiki/Bohr_radius). The alias `bohr` is
  provided for convenient use without Unicode.
* `Eₕ`: the [Hartree energy](https://en.wikipedia.org/wiki/Hartree). The alias `hartree` is
  provided for convenient use without Unicode.

Except for `a₀`/`bohr` and `Eₕ`/`hartree`, these units are not registered in Unitful.jl for
several reasons:

* The units `ħ` and `k` collide with definitions in the Unitful.jl package, where they are
  both defined as constants (not units):
  ```julia
  julia> u"ħ"
  1.0545718001391127e-34 J s
  ```
* While `mₑ` is not defined in Unitful.jl, `me` is, and both represent the electron rest
  mass. Therefore, to avoid confusion, `mₑ` is not registered.
* The symbol `e` is used for Euler’s number in Julia versions < 1.0, where it can also be
  used with `u"..."`.

Therefore, the units `mₑ`, `e`, `ħ`, and `k` are not registered and cannot be used inside
the `u"..."` macro. In most cases, this should not pose a problem since the functions
described above allow converting from and to atomic units without explicitly specifying
them.

Furthermore, this package defines some units that are not atomic units, but are common in
atomic physics. All of these units are registered, so they can be used with the `u"..."`
macro:

* `Ry`: the Rydberg energy `Ry = h*c*R∞ = Eₕ/2`, see
  [Rydberg constant](https://en.wikipedia.org/wiki/Rydberg_constant).
* `μ_N`: the [nuclear magneton](https://en.wikipedia.org/wiki/Nuclear_magneton).
