function [Fmeasure, Confusion, label_aligned] = evalFmeasure(label_true, label_pred)

label_true = label_true(:);
label_pred = label_pred(:);
assert(length(label_true) == length(label_pred));

unique_label_true = unique(label_true);
unique_label_pred = unique(label_pred);

assert(length(unique_label_true) == length(unique_label_pred))
nClass = length(unique_label_true);

G = zeros(nClass);
for ii=1:nClass
	for jj=1:nClass
        n_i = sum(label_true == unique_label_true(ii));
        n_j = sum(label_pred == unique_label_pred(jj));
        n_ij = sum(label_true == unique_label_true(ii) & label_pred == unique_label_pred(jj));
        recall = n_ij / n_i + eps;
        precision = n_ij / n_j + eps;
		G(ii, jj) = harmmean([recall, precision]);
	end
end

[c, v] = hungarian(-G');

Fmeasure = -v / nClass;

label_aligned = zeros(size(label_pred));
for ii = 1:nClass
    label_aligned(label_pred == unique_label_pred(c(ii))) = unique_label_true(ii);
end

Confusion = G(:, c);

end
