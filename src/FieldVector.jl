abstract type FieldVector{N, T} <: StaticVector{N, T} end

# Is this a good idea?? Should people just define constructors that accept tuples?
@inline (::Type{FV})(x::Tuple) where {FV <: FieldVector} = FV(x...)

@propagate_inbounds getindex(v::FieldVector, i::Int) = getfield(v, i)
@propagate_inbounds setindex!(v::FieldVector, x, i::Int) = setfield!(v, i, x)

# See #53
Base.cconvert(::Type{<:Ptr}, v::FieldVector) = Base.RefValue(v)
Base.unsafe_convert(::Type{Ptr{T}}, m::Base.RefValue{FV}) where {N,T,FV<:FieldVector{N,T}} =
    Ptr{T}(Base.unsafe_convert(Ptr{FV}, m))
