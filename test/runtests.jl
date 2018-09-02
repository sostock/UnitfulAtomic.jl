using Unitful
using UnitfulAtomic
@static if VERSION < v"0.7"
    using Base.Test
else
    using Test
end

baseSIunits = (u"m", u"kg", u"s", u"A", u"K")

derivedSIunits = (u"Hz", u"N", u"Pa", u"J", u"W", u"C", u"V", u"Ω", u"S", u"F", u"H", u"T", u"Wb",
                  u"Sv", u"J*s", u"J/K", u"kg*m/s", u"N/m^2", u"V/m", u"V*s/m^2", u"C*m^2")

otherunits = (u"μ_N", u"°")

@testset "aunit" begin
    for u in (baseSIunits..., derivedSIunits..., otherunits...)
        @test dimension(u) ≡ dimension(aunit(u))
        @test aunit(1u) ≡ aunit(u) ≡ aunit(dimension(u))
        @test aunit(u) ≡ aunit(aunit(u))
    end
end

unity = (u"me", u"q", u"ħ", u"1/(4π*ε0)", 1u"a₀", 1u"Eₕ", u"k", 2u"Ry", 2u"μB")

@testset "Atomic units" begin
    for q in unity
        @test austrip(q) ≈ 1
        @test auconvert(unit(q), 1) ≈ q
    end
    @test austrip(u"c0") ≈ 137.035_999_173
end

@testset "Conversion" begin
    for q in (2.818e-15u"m", 9.81u"m/s^2", 1u"Ry")
        @test austrip(q) == ustrip(auconvert(q))
        @test auconvert(unit(q), austrip(q)) ≈ q
    end
    for number in (2, 1.5, 3//2, big(π))
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
