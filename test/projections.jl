function test_orthogonality(chars)
    projs = [*(SymbolicWedderburn.matrix_projection(χ)...) for χ in chars]

    res = map(Iterators.product(projs, projs)) do (p,q)
        if p == q
            # p^2 == p
            all(x->isapprox(0.0, x; atol=1e-12), p^2-p)
        else
            res = p*q
            all(x->isapprox(0.0, x; atol=1e-12), p*q)
        end
    end

    return all(res)
end

@testset "Orthogonality of projections" begin
    G = PermGroup([perm"(1,2,3,4)"])
    chars = SymbolicWedderburn.characters_dixon(Float64, G)
    @test test_orthogonality(chars)
    @test sum(first ∘ size, SymbolicWedderburn.isotypical_basis.(chars)) == degree(G)

    G = PermGroup([perm"(1,2,3,4)", perm"(1,2)"])
    chars = SymbolicWedderburn.characters_dixon(Float64, G)
    @test test_orthogonality(chars)
    @test sum(first ∘ size, SymbolicWedderburn.isotypical_basis.(chars)) == degree(G)

    G = PermGroup([perm"(1,2,3)", perm"(2,3,4)"])
    chars = SymbolicWedderburn.characters_dixon(Float64, G)
    @test test_orthogonality(chars)
    @test sum(first ∘ size, SymbolicWedderburn.isotypical_basis.(chars)) == degree(G)

    for ord in 2:16
        for (i, G) in enumerate(SmallPermGroups[ord])
            @info ord, i, G
            chars = SymbolicWedderburn.characters_dixon(Rational{Int}, G)

            @test test_orthogonality(chars)
            @test sum(first ∘ size, SymbolicWedderburn.isotypical_basis.(chars)) == degree(G)
        end
    end
end

@testset "Symmetry adapted basis" begin
    G = PermGroup([perm"(1,2,3,4)"])
    basis = symmetry_adapted_basis(Complex{Rational{Int}}, G)
    @test sum(first ∘ size, basis) == degree(G)

    G = PermGroup([perm"(1,2,3,4)", perm"(1,2)"])
    basis = symmetry_adapted_basis(ComplexF64, G)
    @test sum(first ∘ size, basis) == degree(G)

    G = PermGroup([perm"(1,2,3)", perm"(2,3,4)"])
    basis = symmetry_adapted_basis(ComplexF64, G)
    @test sum(first ∘ size, basis) == degree(G)

    G = PermGroup([perm"(1,2,3,4)"])
    basis = symmetry_adapted_basis(Rational{Int}, G)
    @test sum(first ∘ size, basis) == degree(G)

    G = PermGroup([perm"(1,2,3,4)", perm"(1,2)"])
    basis = symmetry_adapted_basis(Float64, G)
    @test sum(first ∘ size, basis) == degree(G)

    G = PermGroup([perm"(1,2,3)", perm"(2,3,4)"])
    basis = symmetry_adapted_basis(G)
    @test sum(first ∘ size, basis) == degree(G)
end

