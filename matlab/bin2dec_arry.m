function arry_out = bin2dec_arry(arry_in)
    [px,py] = size(arry_in);
    arry_out = zeros(px,py);
    for j = 1 : py
        for i = 1 : px
            index = 4 - i;
            arry_out(i,j) = arry_in(i,j) * 2^(index);
        end 
    end
    arry_out = sum(arry_out);
end
