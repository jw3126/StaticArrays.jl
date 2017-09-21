struct Size{S}
    function Size{S}() where {S}
        new{S::Tuple{Vararg{Int}}}()
    end
end

@pure Size(s::Tuple{Vararg{Int}}) = Size{s}()
@pure Size(s::Int...) = Size{s}()
@pure Size(s::Type{<:Tuple}) = Size{tuple(s.parameters...)}()

Base.show(io::IO, ::Size{S}) where {S} = print(io, "Size", S)

#= There seems to be a subtyping/specialization bug...
function Size(::Type{SA}) where {SA <: StaticArray} # A nice, default error message for when S not defined
end =#
Size(a::StaticArray{S}) where {S} = Size(S)
Size(a::Type{<:StaticArray{S}}) where {S} = Size(S)

struct Length{L}
    function Length{L}() where L
        check_length(L)
        new{L}()
    end
end

check_length(L::Int) = nothing
check_length(L) = error("Length was expected to be an `Int`")

Base.show(io::IO, ::Length{L}) where {L} = print(io, "Length(", L, ")")

Length(a::StaticArray) = Length(Size(a))
Length(::Type{SA}) where {SA <: StaticArray} = Length(Size(SA))
@pure Length(::Size{S}) where {S} = Length{prod(S)}()
@pure Length(L::Int) = Length{L}()

# Some @pure convenience functions for `Size`
@pure get(::Size{S}) where {S} = S

@pure getindex(::Size{S}, i::Int) where {S} = i <= length(S) ? S[i] : 1

@pure length(::Size{S}) where {S} = length(S)
@pure length_val(::Size{S}) where {S} = Val{length(S)}

# Note - using === here, as Base doesn't inline == for tuples as of julia-0.6
@pure Base.:(==)(::Size{S}, s::Tuple{Vararg{Int}}) where {S} = S === s
@pure Base.:(==)(s::Tuple{Vararg{Int}}, ::Size{S}) where {S} = s === S

@pure Base.:(!=)(::Size{S}, s::Tuple{Vararg{Int}}) where {S} = S !== s
@pure Base.:(!=)(s::Tuple{Vararg{Int}}, ::Size{S}) where {S} = s !== S

@pure Base.prod(::Size{S}) where {S} = prod(S)

@pure @inline Base.sub2ind(::Size{S}, x::Int...) where {S} = sub2ind(S, x...)

# Some @pure convenience functions for `Length`
@pure get(::Length{L}) where {L} = L

@pure Base.:(==)(::Length{L}, l::Int) where {L} = L == l
@pure Base.:(==)(l::Int, ::Length{L}) where {L} = l == L

@pure Base.:(!=)(::Length{L}, l::Int) where {L} = L != l
@pure Base.:(!=)(l::Int, ::Length{L}) where {L} = l != L

# unroll_tuple also works with `Length`
@propagate_inbounds unroll_tuple(f, ::Length{L}) where {L} = unroll_tuple(f, Val{L})


@inline _size(a) = size(a)
@inline _size(a::StaticArray) = Size(a)

# Return static array from a set of arrays
@inline _first_static(a1::StaticArray, as...) = a1
@inline _first_static(a1, as...) = _first_static(as...)
@inline _first_static() = throw(ArgumentError("No StaticArray found in argument list"))

@inline function same_size(as...)
    s = Size(_first_static(as...))
    _sizes_match(s, as...) || _throw_size_mismatch(as...)
    s
end
@inline _sizes_match(s::Size, a1, as...) = ((s == _size(a1)) ? _sizes_match(s, as...) : false)
@inline _sizes_match(s::Size) = true
@noinline function _throw_size_mismatch(as...)
    throw(DimensionMismatch("Sizes $(map(_size, as)) of input arrays do not match"))
end

# Return the "diagonal size" of a matrix - the minimum of the two dimensions
diagsize(A::StaticMatrix) = diagsize(Size(A))
@pure diagsize(::Size{S}) where {S} = min(S...)
