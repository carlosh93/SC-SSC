function n_labels = fix_labels(labels)

lbls = unique(labels);
n_labels = zeros(size(labels));
n_lbls = 1:length(lbls);
for k = 1:length(lbls)
    n_labels(labels==lbls(k)) = n_lbls(k); 
end

end