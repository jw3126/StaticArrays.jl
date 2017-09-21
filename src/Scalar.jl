const Scalar{T} = SArray{Tuple{},T,0,1}

@inline Scalar(x::Tuple{T}) where {T} = Scalar{T}(x[1])
@inline Scalar(a::AbstractArray) = Scalar{typeof(a)}((a,))
@inline Scalar(a::AbstractScalar) = Scalar{eltype(a)}((a[],)) # Do we want this to convert or wrap?
@inline function convert(::Type{SA}, a::AbstractArray) where {SA <: Scalar}
    return SA((a[],))
end

getindex(v::Scalar) = v.data[1]
@inline function getindex(v::Scalar, i::Int)
    @boundscheck if i != 1
        error("Attempt to index Scalar at index $i")
    end
    v.data[1]
end

# A lot more compact than the default array show
Base.show(io::IO, ::MIME"text/plain", x::Scalar{T}) where {T} = print(io, "Scalar{$T}(", x.data, ")")

# Simplified show for the type
show(io::IO, ::Type{Scalar{T}}) where {T} = print(io, "Scalar{T}")
