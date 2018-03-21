"""
    random_cover(n, d, max_rad, sides)

Generate n circles with random radii between 0 and max_rad and random
centers chosen in a d dimensional box of with side length "sides".

"""

function random_cover(n, d, max_rad, sides)
    centers = sides * rand(n, d)
    radii =  max_rad * rand(n)
    return (centers, radii)
end


"""
    distance(x,y)

Gives the Euclidean distance between x and y.

# Examples

```jldoctest
julia> distance([0,1], [1,0])
1.41...
```
"""

function distance(x, y)
    diffs_squared = [(x[i]-y[i])^2 for i in 1:length(x)]
    return sqrt(sum_kbn(diffs_squared))
end


"""
    rand_2d_circle_code(n, max_rad, sides)

Generates n random circles of radius less than r and centers in a s by s square, and returns both the data of the cover and the code of a cover. For some reason, this is faster than using cover_to_code on the output of random_cover.

Our convention is to omit the empty codeword.

"""

function rand_2d_circle_code(n, max_rad, sides)
    coords = [(x, y) for x in -max_rad:sides+max_rad, y in -max_rad:sides+max_rad]
    (centers, radii) = random_cover(n, 2, max_rad, sides)
    codewords = []
    for (x, y) in coords
        codeword = []
        for i in 1:n
            if distance([centers[i,1], centers[i,2]], [x, y]) < radii[i]
                push!(codeword, i)
            end
        end
        if in(codeword, codewords) == false && size(codeword)[1] > 0
            push!(codewords, codeword)
        end
    end
    return ((centers, radii), codewords)
end

"""
    cover_to_code(centers, radii, sides)

Given the data of a cover of circles given as lists of centers and radii,
and a number sides giving the sidelength of a box containing the centers of the
circles, this computes the code of the cover. This is slower than
rand_2d_circle_code for n=2, and too slow to be practical for n>2.

Our convention is to omit the empty codeword.
"""

function cover_to_code(centers, radii, sides)
    n = size(radii)[1]
    b = maximum(radii)
    dims = tuple(fill( ceil(Int, sides + 2*b), n )...)
    codewords = []
    for index in CartesianRange(dims) #need to make dims a tuple, somehow
        point = [(index.I[i])-b for i = 1:n]
        codeword = []
        for i in 1:n
            if distance(centers[i], point) < radii[i]
                push!(codeword, i)
            end
        end
        if in(codeword, codewords) == false && size(codeword)[1] > 0
            push!(codewords, codeword)
        end
    end
    return codewords
end

"""
    support_to_vector(codeword, n)

Given a codeword on n neurons presented as a list of integers between 1 and n,
returns a codeword on n neurons presented as binary vector of length n.
"""
function support_to_vector(codeword,n)
    vector = fill(0, n)
    for i in codeword
        vector[i]=1
    end
    return vector
end

"""
    supports_to_vectors(code, n)

Given a neural code presented as a list of codewords, each presented as a list
of integers between 1 and n, returns the neural code as a list of binary vectors
of length n.
"""
function supports_to_vectors(code, n)
    return [support_to_vector(codeword, n) for codeword in code]
end
