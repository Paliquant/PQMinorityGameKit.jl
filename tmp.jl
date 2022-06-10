m = 5
game_array = [-1,1,1,1,-1]

# convert this to binary (-1 => 0)
binary_game_array = replace(x->x==-1 ? x=0 : x=1, game_array)

# what Int does this correspond to?
str_buffer = ""
for i ∈ 1:m
    global str_buffer*="$(binary_game_array[i])"
end