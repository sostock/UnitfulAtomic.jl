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
    @test austrip(u"c0") ≈ 137.035_999_173
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
