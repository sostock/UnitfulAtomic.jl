# UnitfulAtomic release notes

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

## v0.1.0

Initial release. This release only supports Unitful ≤ 0.13.0.
