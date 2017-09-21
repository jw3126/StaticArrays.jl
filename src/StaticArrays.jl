__precompile__()

module StaticArrays

import Base: @_inline_meta, @_propagate_inbounds_meta, @_pure_meta, @propagate_inbounds, @pure

import Base: getindex, setindex!, size, similar, vec, show,
             length, convert, promote_op, promote_rule, map, map!, reduce, reducedim, mapreducedim,
             mapreduce, broadcast, broadcast!, conj, transpose, ctranspose,
             hcat, vcat, ones, zeros, eye, one, cross, vecdot, reshape, fill,
             fill!, det, logdet, inv, eig, eigvals, eigfact, expm, logm, sqrtm, lyap, trace, kron, diag, vecnorm, norm, dot, diagm, diag,
             lu, svd, svdvals, svdfact, factorize, ishermitian, issymmetric, isposdef,
             iszero, sum, diff, prod, count, any, all, minimum,
             maximum, extrema, mean, copy, rand, randn, randexp, rand!, randn!,
             randexp!, normalize, normalize!, read, read!, write, Eigen

export StaticScalar, StaticArray, StaticVector, StaticMatrix
export Scalar, SArray, SVector, SMatrix
export MArray, MVector, MMatrix
export FieldVector
export SizedArray, SizedVector, SizedMatrix
export SDiagonal

export Size, Length

export @SVector, @SMatrix, @SArray
export @MVector, @MMatrix, @MArray

export similar_type
export push, pop, shift, unshift, insert, deleteat, setindex

abstract type StaticArray{S <: Tuple, T, N} <: AbstractArray{T, N} end
const StaticScalar{T} = StaticArray{Tuple{}, T, 0}
const StaticVector{N, T} = StaticArray{Tuple{N}, T, 1}
const StaticMatrix{N, M, T} = StaticArray{Tuple{N, M}, T, 2}

const AbstractScalar{T} = AbstractArray{T, 0} # not exported, but useful none-the-less
const StaticArrayNoEltype{S, N, T} = StaticArray{S, T, N}

include("util.jl")
include("traits.jl")
include("convert.jl")

include("SUnitRange.jl")
include("FieldVector.jl")
include("SArray.jl")
include("SMatrix.jl")
include("SVector.jl")
include("Scalar.jl")
include("MArray.jl")
include("MVector.jl")
include("MMatrix.jl")
include("SizedArray.jl")
include("SDiagonal.jl")

include("abstractarray.jl")
include("indexing.jl")
include("broadcast.jl")
include("mapreduce.jl")
include("arraymath.jl")
include("linalg.jl")
include("matrix_multiply.jl")
include("det.jl")
include("inv.jl")
include("solve.jl")
include("eigen.jl")
include("expm.jl")
include("sqrtm.jl")
include("lyap.jl")
include("triangular.jl")
include("cholesky.jl")
include("svd.jl")
include("lu.jl")
include("deque.jl")
include("io.jl")

include("FixedSizeArrays.jl")
include("ImmutableArrays.jl")

end # module
