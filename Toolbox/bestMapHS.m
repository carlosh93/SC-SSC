function [new_g] = bestMapHS(groups,labels)
%   [newL2] = bestMapHS(L1,L2);
%========================================================================%

new_g = bestMap(labels, groups);
crV=[];
u1= unique(labels);
u1(1)=[];
u2 = unique(new_g);

for ii =1:length(u1)
    if ~ismember(u1(ii),u2)
        crV = u1(ii);
        break;
    end
end

if ~isempty(crV)
    new_g(new_g==1)=crV;
end

new_g = new_g';
end
