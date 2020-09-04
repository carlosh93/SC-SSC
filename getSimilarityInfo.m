function [segm, CenT, U, W, info] = getSimilarityInfo(Hyperimg, cube_size, Nseg,Cflag)

if nargin < 4
    Cflag = false;
end

tic
Mc = cube_size(1);
Nc = cube_size(2);

[~,N] = size(Hyperimg);

data_pca = hyperPct(Hyperimg,3); 
data_pca = bsxfun(@minus, data_pca, mean(data_pca, 2)); % mean subtraction
data_pca = cnormalize_inplace(data_pca);
data_pca = reshape(data_pca',[Mc,Nc,3]);

I(:,:,1) = 255*mat2gray(data_pca(:,:,1));
I(:,:,2) = 255*mat2gray(data_pca(:,:,2));
I(:,:,3) = 255*mat2gray(data_pca(:,:,3));

I = uint8(I);

gauss=fspecial('gaussian',3); I=imfilter(I,gauss);


[segm,Nseg] = superpixels(I,Nseg,'compactness',50);

if Cflag
    s = regionprops(segm,'centroid');
    CenT = round(cat(1,s.Centroid));
    CenT = sub2ind([Mc,Nc],CenT(:,2),CenT(:,1));
else
    CenT = [];
end

val1          = [];
val2          = [];
idxx          = [];
idxy          = [];
for nseg = 1:Nseg
    idx       = find(segm(:) == nseg);
    idxx      = [idxx; idx];
    idxy      = [idxy; ones(length(idx), 1)*nseg];
    val1      = [val1; ones(length(idx), 1)];
    val2      = [val2; 1./length(idx)];
end
U             = sparse(idxy, idxx, val1, Nseg, N);
W             = sparse(1:Nseg, 1:Nseg, val2, Nseg, Nseg);
Uw            = W*U;

info.overall_time = toc;

end
