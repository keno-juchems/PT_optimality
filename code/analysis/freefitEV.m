function [loss,modelcp] = freefit(x,p);

indx = x.indx;
V = x.V(:,indx);
P = x.P(:,indx);
EU = x.Y(:,indx);

vv = unique(V);
pp = unique(P);

wv = p(1:length(vv));
wp = p(length(vv)+1:length(vv)+length(pp));
sigma = p(length(vv)+length(pp)+1);
lapse = 0;
bias = 0;

xV = V*0;
xP = P*0;

for i = 1:length(vv);
    xV(find(V==vv(i))) = wv(i);
    xP(find(P==pp(i))) = wp(i);
end

%disp(num2str(sum(abs(wv))));

xDV = xV.*xP;
DV = (xDV(1,:)-xDV(2,:));

modelcp = lapse + (1-(lapse*2)) ./ (1 + exp(-(DV-bias)/sigma)); %fitting function

loss = -mean((modelcp.*EU(1,:)) + ((1-modelcp).*EU(2,:)));


% xx = (DV-bias)/sigma;
% zz = humchoice;
% like = max(xx, 0) - xx.*zz + log(1 + exp(-abs(xx)));
% like(isnan(like) & (modelcp==zz)) = 0;
% like(isnan(like) & (modelcp~=zz)) = inf;
% negloglike = mean(like);

% modelcp = 1./(1+exp(-DV./sigma));
%like = 1-abs(humchoice-modelcp);
%negloglike = -sum(log(like));