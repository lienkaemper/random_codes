# inputs: n - number of neurons, d-dimension, a-side length of box
# b- max radius
# output: (centers, radii). centers is a list of n random points chose uniformly at random (I hope...) from a cube in R^d with side length a. radii is a list of n random numbers between 0 and b.
#you should think of this output as specifying n random balls in a d-dimensional box. and you should think of the balls as place fields.
function random_cover(n, d, a, b)
    centers = a * rand(n, d)
    radii =  b * rand(n)
    return (centers, radii)
end


#given two points in R^k, returns the distance between them
#inputs: two lists or tuples or numbers
function distance(x, y)
    diffs_squared = [(x[i]-y[i])^2 for i in 1:length(x)]
    return sqrt(sum_kbn(diffs_squared))
end

#= makes a random n neuron code whose place fields are filled
circles with radius 0 to b whose centers are in an a by a box =#
#= input: n-number of neurons, an integer
          a-box size, an integer
          b-max radius size, doesn't need to be an int =#

function rand_2d_circle_code(n, a, b)
    coords = [(x, y) for x in -b:a+b, y in -b:a+b]
    (centers, radii) = random_cover(n, 2, a, b)
    codewords = []
    for (x, y) in coords
        codeword = []
        for i in 1:n
            if distance(centers[i], [x, y]) < radii[i]
                push!(codeword, i)
            end
        end
        if in(codeword, codewords) == false && size(codeword)[1] > 0
            push!(codewords, codeword)
        end
    end
    return codewords
end

#= given a cover, a number giving the box size of the code, give the code of the
cover =#
#=inputs: centers--a list of n d-tuples, where n is the number of neuons and
d is the dimension, giving the centers of the place fields
           radiii - a n-tuple of numbers, giving the radii of the place fields
           a - an integer, the box size =#
#=output: a list of codewords, given as subsets of [n]=#

function cover_to_code(centers, radii, a)
    n = size(radii)[1]
    b = maximum(radii)
    dims = tuple(fill( ceil(Int, a + 2*b), n )...)
    print(dims)
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

#=convert codeword in support form to codeword in vector form=#
#=input: codeword--a list of integers
         n--the number of neurons the codeword is on =#
#=output: a n entry list with a 1 at the ith entry if i\in codeword and a 0
at the nth entry otherwise =#
function support_to_vector(codeword,n)
    vector = fill(0, n)
    for i in codeword
        vector[i]=1
    end
    return vector
end

#converts a neural code from support form to vector form
#=imputs: code -- a list of lists, each containing a subset of 1:n
          n -- an integer =#
#=outputs: a list of lists of length n, each containing 0's and 1's =#
function supports_to_vectors(code, n)
    return [support_to_vector(codeword, n) for codeword in code]
end
