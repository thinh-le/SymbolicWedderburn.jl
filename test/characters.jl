@testset "Frobenius-Schur & projections" begin
    G = SmallPermGroups[8][4]
    ccG = conjugacy_classes(G)

    # quaternionic character
    χ = SymbolicWedderburn.Character(Float64[2, 0, 0, -2, 0], ccG)

    @test SymbolicWedderburn.frobenius_schur_indicator(χ) == -1
    @test PermutationGroups.degree(χ) == 2
    @test size(SymbolicWedderburn.isotypical_basis(χ), 1) == 4

    @test deepcopy(χ) == χ
    @test deepcopy(χ) !== χ

    ψ = SymbolicWedderburn.Character(copy(values(χ)), conjugacy_classes(χ))

    @test ψ == χ
    @test ψ !== χ
    @test ψ == deepcopy(χ)

    @test ψ.cc === χ.cc
    @test conjugacy_classes(ψ) === conjugacy_classes(χ)

    @test values(ψ) == values(χ)
    @test values(ψ) !== values(χ)

    @test hash(ψ) == hash(χ)

    @test 2ψ == 2χ
    @test 2ψ/2 == χ
    @test 2ψ != χ
    @test hash((2ψ/2).vals) == hash(χ.vals)

    @test SymbolicWedderburn.affordable_real!(χ) isa SymbolicWedderburn.Character

end
