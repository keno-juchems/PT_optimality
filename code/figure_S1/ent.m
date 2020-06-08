%% Computes the entropy from probability of success

function out = ent(p)

out = -(p.*log(p)+(1-p).*log(1-p));

% Fix boundary cases, where log(q) --> -Inf
out(p >1-1e-10) = 0;
out(p <1e-10) = 0;

end