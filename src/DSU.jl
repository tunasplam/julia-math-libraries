#=
Disjoint Set Unions
https://cp-algorithms.com/data_structures/disjoint_set_union.html

When we have several elements, each of which is a separate set,
a DUS will have an operation to combine any two sets
and it will be able to tell in which set a specific element is in.

Three basic operations:

- make_set(v) - creats a new set of the element v

- union_sets(a, b) - unions two specified sets (the set in which
the element a is located and the set inwhich b is located).

- find_set(v) - returns the representative (or leader) of the set that
contains the element v. This is an element of its corresponding set. It is
selected in each set by the data structure (and can change over time when
union_sets() is called). This representative can be used to tell if two elements
are part of the same set. a and b are exactly in the same set if:
    find_set(a) == find_set(b).

Pretty much all of the above operations are O(1) on average.

Sets are stored in the form of trees: each tree will correspond to one set.
The root of the tree is the representative of the set.

For implementation, we need to maintain an array `parent` that stores a reference
to its immediate ancestor in the tree.
=#

#=
    Below is the naive (inefficent) implementation of a DSU. However,
    it is very instructive for understanding how things work.

    # this array keeps track of each nodes ancestor (parent).
    parent = Vector{Int}()

    function make_set(v::Int)
        #=
        Creates a new set by creating a tree with root v.
        Note that v is its own ancestor!
        =#
        parent[v] = v
    end

    function find_set(v::Int)::Int
        # this returns the root (representaive) of the set
        # in which v is a part of.
        # Climb the parents until you reach the root.
        return v == parent[v] ? v : find_set(parent[v])
    end

    function union_sets(a::Int, b::Int)
        # find representative of elements a and b
        a, b = find_set(a), find_set(b)
        # if they are in different sets, then the parent
        # of b is now a. Otherwise, do nothing (A ∪ A = A)
        if a != b
            parent[b] = a
        end
    end
=#

#=
This implementation assumes that all elements are unique!!!
Make sure the size can fit in RAM :)

NOTE there are ALWAYS more optimizations depending on your specific use-case!
Check the link above!
=#

mutable struct DSU
    # supposedly julia does better with Dicts here instead of sparse arrays
    parent::Dict{Int, Union{Int, Nothing}}
    # see union_set() for details
    size::Dict{Int, Union{Int, Nothing}}

    # this is the actual constructor. This constructs parent and size.
    function DSU()
        new(Dict{Int, Union{Int, Nothing}}(), Dict{Int, Union{Int, Nothing}}())
    end
end

function find_set(D::DSU, v::Int)::Int
    #= Returns the representaive (root) of the set in which
    v is a part of.

    This uses path compression. Long chains are 'compressed' by setting
    each node in a chain's parent to be the root node rather than its
    immediate parent. You really need to see the image on the link above
    to fully grasp whats going on here.

    NOTE that this makes future calls of find_set much more efficient because
    calls to nodes further down the tree will be "shortcut" to their roots. It
    is kind of like "memoizing" the root of each node which is processed.

    This is O(log n) on average.
    =#
    return v == D.parent[v] ? v : D.parent[v] = find_set(D, D.parent[v])
end

function make_set!(D::DSU, v::Int)
    #=
    Creates a new set by creating a tree with root v.
    Note that v is its own ancestor!
    =#
    D.parent[v] = v
    # whatever heurstic function that you are using in union_set
    # gets instantiated here.
    D.size[v] = 1
end

function union_set!(D::DSU, a::Int, b::Int)::Int
    #= This optimized version of union_set() allows us to select which
    tree gets unioned with the other (as opposed to the naive approach
    where the second always gets unioned with the first, leading to trees
    containing chains of length O(n)).

    You can use many heuristics to make this more efficient. For example, you
    can rank trees by size or by depth. All-in-all, attach the tree with the
    lower rank to the one with the larger rank.

    This implementation uses size.
    =#
    a, b = find_set(D, a), find_set(D, b)
    if a != b
        # rank is an array that stores the results of the hueristic function
        # for each tree. The representaives are the indicies and their
        # ranks are the values.
        if D.size[a] < D.size[b]
            a, b = b, a
        end
        D.parent[b] = a
        D.size[a] += D.size[a]
    end
end
