module UnitfulAtomic

import Unitful
using Unitful: @unit, Dimension, Dimensions, NoDims, NoUnits, Units, dimension, uconvert, ustrip

export auconvert, aunit, austrip

# The following five constants are used as the “base” atomic units
@unit me_au "mₑ"  ElectronRestMass      Unitful.me                     false
@unit e_au  "e"   ElementaryCharge      Unitful.q                      false
@unit ħ_au  "ħ"   ReducedPlanckConstant Unitful.ħ                      false
@unit k_au  "k"   BoltzmannConstant     Unitful.k                      false
@unit a0_au "a₀"  BohrRadius            5.291_772_109_03e-11*Unitful.m false # CODATA 2018 recommended value

# Hartree energy is derived from the base atomic units
@unit Eh_au "Eₕ"  HartreeEnergy         1ħ_au^2/(me_au*a0_au^2)       false

# Units that are not Hartree atomic units, but are commonly used in atomic physics
@unit Ry    "Ry"  RydbergEnergy         Eh_au//2                      false
@unit μ_N   "μ_N" NuclearMagneton       e_au*ħ_au/(2*Unitful.mp)      false

# Aliases for units
const bohr    = a0_au
const hartree = Eh_au

"""
    aunit(x::Unitful.Quantity)
    aunit(x::Unitful.Units)
    aunit(x::Unitful.Dimensions)

Returns the appropriate atomic unit (a `Unitful.Units` object) for the dimension of `x`.

# Examples

```jldoctest
julia> aunit(2.3u"cm")
a₀

julia> aunit(u"T")
a₀^-2 e^-1 ħ
```
"""
aunit(x) = aunit(dimension(x))

# `aunit` for `Dimension` types
aunit(x::Dimension{:Length})      = (a0_au)^x.power
aunit(x::Dimension{:Mass})        = (me_au)^x.power
aunit(x::Dimension{:Time})        = (ħ_au/Eh_au)^x.power
aunit(x::Dimension{:Current})     = (e_au*Eh_au/ħ_au)^x.power
aunit(x::Dimension{:Temperature}) = (Eh_au/k_au)^x.power

# For dimensions not specified above, there is no atomic unit.
aunit(::Dimension{D}) where D = throw(ArgumentError("no atomic unit defined for dimension $D."))

# `aunit` for `Dimensions` types
@generated aunit(::Dimensions{N}) where N = prod(aunit, N)
aunit(::typeof(NoDims)) = NoUnits

# Simplifications for some derived dimensions, so that e.g. `aunit(u"J")` returns `Eₕ`
# instead of `a₀^2 mₑ Eₕ^2 ħ^-2`. The following units/dimensions are considered:
#   * Energy: Eₕ
#   * Momentum: ħ/a₀
#   * Action/angular momentum: ħ
#   * Force: Eₕ/a₀
#   * Pressure: Eₕ/a₀^3
#   * E-field: Eₕ/(e*a₀)
#   * B-field: ħ/(e*a₀^2)
#   * Voltage/electric potential: Eₕ/e
#   * Magnetic dipole moment: e*ħ/mₑ
#   * Entropy: k
#   * 1st hyperpolarizability: e^3*a₀^3/Eₕ^2
#   * 2nd hyperpolarizability: e^4*a₀^4/Eₕ^3
#   * E-field gradient: Eₕ/(e*a₀^2)
#   * Electric polarizability: e^2*a₀^2/Eₕ
#   * Permittivity: e^2/(a₀*Eₕ)
for unit in (:(Eh_au), :(ħ_au/a0_au), :(ħ_au), :(Eh_au/a0_au), :(Eh_au/a0_au^3),
             :(Eh_au/(e_au*a0_au)), :(ħ_au/(e_au*a0_au^2)), :(Eh_au/e_au), :(e_au*ħ_au/me_au),
             :(k_au), :(e_au^3*a0_au^3/Eh_au^2), :(e_au^4*a0_au^4/Eh_au^3),
             :(Eh_au/(e_au*a0_au^2)), :(e_au^2*a0_au^2/Eh_au), :(e_au^2/(a0_au*Eh_au)))
    @eval aunit(::typeof(dimension($unit))) = $unit
end

"""
    auconvert(x::Unitful.Quantity)

Convert a quantity to the appropriate atomic unit.

# Examples

```jldoctest
julia> auconvert(13.6u"eV")
0.4997907858599377 Eₕ

julia> auconvert(20u"nm")
377.94522509156565 a₀
```
"""
auconvert(x) = uconvert(aunit(x), x)

"""
    auconvert(u::Unitful.Units, x::Number)

Interpret `x` as a quantity given in atomic units and convert it to the unit `u`.

# Examples

```jldoctest
julia> auconvert(u"eV", 1)  # convert 1 Eₕ to eV
27.211386013449417 eV

julia> auconvert(u"m", 1)   # convert 1 a₀ to m
5.2917721067e-11 m
```
"""
auconvert(u::Units, x::Number) = uconvert(u, x*aunit(u))

"""
    austrip(x::Unitful.Quantity)

Returns the value of the quantity converted to atomic units as a number type (i.e., with the
units removed). This is equivalent to `Unitful.ustrip(auconvert(x))`.

# Examples

```jldoctest
julia> austrip(13.6u"eV")
0.4997907858599377

julia> austrip(20u"nm")
377.94522509156565
```
"""
austrip(x) = ustrip(auconvert(x))

# In order to enable precompilation, some things need to be set at runtime
__init__() = Unitful.register(UnitfulAtomic)

end # module UnitfulAtomic
