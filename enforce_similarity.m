function new_W = enforce_similarity(W,kernel_size)

kernel = ones(kernel_size)/pow2(kernel_size);
dims = [sqrt(size(W,2)) size(W,1)];
W_tmp = reshape(W',[dims(1),dims(1),dims(2)]);
W_tmp = imfilter(W_tmp,kernel,'symmetric');
new_W = reshape(W_tmp,[dims(1)*dims(1),dims(2)])';

end
