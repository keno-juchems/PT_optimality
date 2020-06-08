%%

function [this_mean] = get_point_loss_SS16(true_left_v,true_left_p,true_right_v,true_right_p,true_left_EV,this_right,noise_left_v,noise_left_p,alpha,gamma,sigma)

% Pass lottery through non-linearity
this_left    = get_pt_gain_utility(noise_left_v,alpha) .* get_pt_prob(noise_left_p,gamma);

% Pass safe option through non-linearity
true_right = this_right;
this_right = get_pt_gain_utility(this_right,alpha);

% Decision rule
this_mean(this_left >= this_right) = true_left_EV(this_left >= this_right);

% Calculate return
if numel(this_right) == 1
    this_mean(this_left <  this_right) = true_right;
else
    this_mean(this_left <  this_right) = true_right(this_left < this_right);
end
this_mean = mean(this_mean);

end