# UnitfulAtomic release notes

## v0.3.0

* Update physical constants to CODATA 2018 recommended values (**BREAKING**)
* Simplify some atomic units (**BREAKING**):
  - 1st hyperpolarizability: `e^3*a₀^3/Eₕ^2`
  - 2nd hyperpolarizability: `e^4*a₀^4/Eₕ^3`
  - E-field gradient: `Eₕ/(e*a₀^2)`
  - Electric polarizability: `e^2*a₀^2/Eₕ`
  - Permittivity: `e^2/(a₀*Eₕ)`
* This release is compatible with Julia ≥ 0.7 and Unitful ≥ 0.16

## v0.2.0

* Change names of atomic units to remove name clashes (**BREAKING**):
  * `mₑ` → `me_au`
  * `e` → `e_au`
  * `ħ` → `ħ_au`
  * `k` → `k_au`
  * `a₀` → `a0_au`
  * `Eₕ` → `Eh_au`
* Register all units for usage with `@u_str`
* Compatibility with Unitful 0.14.0 (cf.
  [ajkeller34/Unitful.jl#201](https://github.com/ajkeller34/Unitful.jl/pull/201))
* Since this version uses the CODATA 2014 recommended values, it does not support
  Unitful ≥ 0.16

## v0.1.0

Initial release. This release only supports Unitful ≤ 0.13.0.
