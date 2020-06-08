%%

function [this_mean,p_left] = get_point_loss(left_v,left_p,right_v,right_p,left,right,alpha,gamma,sigma,flag)

% Distortions
this_left    = get_pt_gain_utility(left_v,alpha) .* get_pt_prob(left_p,gamma);
this_right   = get_pt_gain_utility(right_v,alpha) .* get_pt_prob(right_p,gamma);

% Choice rule 
if sigma > 1e5
    p_left = double(this_left > this_right);
else
    p_left  = sigmoid([0,sigma],this_left-this_right);
end

% Loss function
if strcmp(flag,'with_entropy')
    this_mean = mean([p_left .* left .* (1-ent(left_p)) + (1-p_left) .* right .* (1-ent(right_p))]);
else
    this_mean = mean([p_left .* left + (1-p_left) .* right]);
end

end