function [loss,modelcp,DV] = fitEV(inout,p);

kappa = exp(p(1));
gamma = exp(p(2));
delta = exp(p(3));
sigma = p(4);
lapse = p(5);

V = inout.V;
P = inout.P;
U = inout.U;

eval(['xV = ',inout.kappa_funct,';']);
eval(['xP = ',inout.gamma_funct,';']);

xDV = xV.*xP;
DV = xDV(1,:)-xDV(2,:);

modelcp = lapse + (1-(lapse*2)) ./ (1 + exp(-DV/sigma)); %fitting function
modelcp(DV==0) = 0.5;

loss = -mean((modelcp.*U(1,:)) + ((1-modelcp).*U(2,:)));

