function out = sigmoid(beta,x)
out = 1./(1+exp(-(beta(:,2).*(x-beta(:,1)))));
end