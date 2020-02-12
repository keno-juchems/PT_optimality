function [X1 T1 EV1 v1 p1 X2 T2 EV2 v2 p2] = makeprospectoddeven(pmat,vmat,removetrivial)

if nargin < 3
    removetrivial = 0;
end

[vx,vy,px,py] = ndgrid(1:length(vmat),1:length(vmat),1:length(pmat),1:length(pmat));
vv = [vx(:) vy(:)]';
pp = [px(:) py(:)]';

vv = shuffle(vv,2);
pp = shuffle(pp,2);

v1 = vv(:,1:(size(vv,2)/2));
p1 = pp(:,1:(size(pp,2)/2));

v2 = vv(:,(size(vv,2)/2)+1:end);
p2 = pp(:,(size(pp,2)/2)+1:end);

if removetrivial
    rm1 = find((v1(1,:) > v1(2,:) & p1(1,:) > p1(2,:)) | (v1(1,:) < v1(2,:) & p1(1,:) < p1(2,:)));
    rm2 = find((v2(1,:) > v2(2,:) & p2(1,:) > p2(2,:)) | (v2(1,:) < v2(2,:) & p2(1,:) < p2(2,:)));
    rmx1 = setdiff(1:size(v1,2),rm1);
    rmx2 = setdiff(1:size(v1,2),rm2);
    v1 = v1(:,rmx1);
    v2 = v2(:,rmx2);
    p1 = p1(:,rmx1);
    p2 = p2(:,rmx2);
end

% training set

EV1 = vmat(v1).*pmat(p1);
EVdiff = EV1(1,:) - EV1(2,:);

indx = find(EVdiff~=0);
v1 = v1(:,indx);
p1 = p1(:,indx);
EV1 = EV1(:,indx);
T1 = double(EV1(1,:)>EV1(2,:))';

X1 = zeros(length(indx),40);

for i = 1:length(indx)
    X1(i,[v1(1,i) v1(2,i)+10 p1(1,i)+20 p1(2,i)+30 41]) = 1;
end

% test set

EV2 = vmat(v2).*pmat(p2);
EVdiff = EV2(1,:) - EV2(2,:);

indx = find(EVdiff~=0);
v2 = v2(:,indx);
p2 = p2(:,indx);
EV2 = EV2(:,indx);
T2 = double(EV2(1,:)>EV2(2,:))';

X2= zeros(length(indx),40);

for i = 1:length(indx)
    X2(i,[v2(1,i) v2(2,i)+10 p2(1,i)+20 p2(2,i)+30 41]) = 1;
end

