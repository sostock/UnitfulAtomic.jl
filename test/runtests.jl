using Unitful
using UnitfulAtomic
@static if VERSION < v"0.7"
    using Base.Test
else
    using Test
end

siunits = (u"m", u"kg", u"s", u"A", u"K", # base units
           u"Hz", u"N", u"Pa", u"J", u"W", u"C", u"V", u"Ω", u"S", u"F", u"H", u"T", u"Wb", u"Sv",
           u"J*s", u"J/K", u"kg*m/s", u"N/m^2", u"V/m", u"V*s/m^2", u"C*m^2")

atomicunits = (u"me_au", u"e_au", u"ħ_au", u"k_au", u"a0_au", # base units
               u"Eh_au", u"ħ_au/a0_au", u"ħ_au/Eh_au")

otherunits = (u"μ_N", u"Ry", u"°", NoUnits)

@testset "aunit" begin
    for u in (siunits..., otherunits...)
        @test dimension(u) ≡ dimension(aunit(u))
        @test aunit(1u) ≡ aunit(u) ≡ aunit(dimension(u))
        @test aunit(u) ≡ aunit(aunit(u))
    end
    for u in atomicunits
        @test aunit(u) ≡ u
    end
    @test aunit(u"a0_au^2*me_au*Eh_au^2/ħ_au^2") ≡ u"Eh_au"
end

unity = (1, u"me", u"q", u"ħ", u"1/(4π*ε0)", u"k", 2u"Ry", 2u"μB")

@testset "Atomic units" begin
    for q in unity
        @test austrip(q) ≈ 1
        @test auconvert(unit(q), 1) ≈ q
    end
    for u in atomicunits
        @test austrip(1u) ≈ 1
        @test auconvert(u, 1) ≈ 1u
    end
    # CODATA 2018 values
    @test austrip(u"c0") ≈ 137.035_999_084
    for (si,au) in ((3.206_361_3061e-53u"C^3*m^3*J^-2",   u"e_au^3*a0_au^3/Eh_au^2"), # 1st hyperpolarizability
                    (6.235_379_9905e-65u"C^4*m^4*J^-3",   u"e_au^4*a0_au^4/Eh_au^3"), # 2nd hyperpolarizability
                    (1.054_571_817e-34u"J*s",             u"ħ_au"),                   # action
                    (1.602_176_634e-19u"C",               u"e_au"),                   # charge
                    (1.081_202_384_57e+12u"C*m^-3",       u"e_au/a0_au^3"),           # charge density
                    (6.623_618_237_510e-3u"A",            u"e_au*Eh_au/ħ_au"),        # current
                    (8.478_353_6255e-30u"C*m",            u"e_au*a0_au"),             # electric dipole moment
                    (5.142_206_757_63e+11u"V*m^-1",       u"Eh_au/e_au/a0_au"),       # electric field
                    (9.717_362_4292e+21u"V*m^-2",         u"Eh_au/e_au/a0_au^2"),     # electric field gradient
                    (1.648_777_274_36e-41u"C^2*m^2*J^-1", u"e_au^2*a0_au^2/Eh_au"),   # electric polarizability
                    (27.211_386_245_988u"V",              u"Eh_au/e_au"),             # electric potential
                    (4.486_551_5246e-40u"C*m^2",          u"e_au*a0_au^2"),           # electric quadrupole moment
                    (4.359_744_722_2071e-18u"J",          u"Eh_au"),                  # energy
                    (8.238_723_4983e-8u"N",               u"Eh_au/a0_au"),            # force
                    (5.291_772_109_03e-11u"m",            u"a0_au"),                  # length
                    (1.854_802_015_66e-23u"J*T^-1",       u"ħ_au*e_au/me_au"),        # magnetic dipole moment
                    (2.350_517_567_58e+5u"T",             u"ħ_au/e_au/a0_au^2"),      # magnetic flux density
                    (7.891_036_6008e-29u"J*T^-2",         u"e_au^2*a0_au^2/me_au"),   # magnetizability
                    (9.109_383_7015e-31u"kg",             u"me_au"),                  # mass
                    (1.992_851_914_10e-24u"kg*m*s^-1",    u"ħ_au/a0_au"),             # momentum
                    (1.112_650_055_45e-10u"F*m^-1",       u"e_au^2/a0_au/Eh_au"),     # permittivity
                    (2.418_884_326_5857e-17u"s",          u"ħ_au/Eh_au"),             # time
                    (2.187_691_263_64e+6u"m*s^-1",        u"a0_au*Eh_au/ħ_au"))       # velocity
        @eval @test aunit($si) ≡ $au
        @eval @test auconvert($si) ≈ 1*$au
    end
end

@testset "Aliases" begin
    @test u"hartree" ≡ u"Eh_au"
    @test 1.0u"hartree" ≡ 1.0u"Eh_au"
    @test u"bohr" ≡ u"a0_au"
    @test 1.0u"bohr" ≡ 1.0u"a0_au"
end

@testset "Conversion" begin
    for q in (2.818e-15u"m", 9.81u"m/s^2", 1u"Ry")
        @test austrip(q) == ustrip(auconvert(q))
        @test auconvert(unit(q), austrip(q)) ≈ q
    end
    for number in (2, 1.5, 3//2, big(π))
        @test aunit(number) ≡ NoUnits
        @test auconvert(number) == number
        @test austrip(number) == number
    end
end

@testset "Type inference" begin
    for q in (1u"m", 1.0u"J", 3//2*u"C*m^2")
        @test @inferred(aunit(q)) ≡ aunit(q)
        @test @inferred(auconvert(q)) ≡ auconvert(q)
        @test @inferred(auconvert(unit(q), ustrip(q))) ≡ auconvert(unit(q), ustrip(q))
        @test @inferred(austrip(q)) ≡ austrip(q)
    end
end

@dimension 𝛁 "𝛁" TestDim
@refunit ∇ "∇" TestUnit 𝛁 false

@testset "Unsupported dimensions" begin
    for u in (∇, u"cd", u"mol", u"g/mol")
        @test_throws ArgumentError aunit(dimension(u))
        @test_throws ArgumentError aunit(u)
        @test_throws ArgumentError aunit(1.0u)
        @test_throws ArgumentError auconvert(1.0*∇)
        @test_throws ArgumentError auconvert(∇, 1.0)
        @test_throws ArgumentError austrip(1.0*∇)
    end
end
