%%


function [true_left_p,true_left_v,true_right_p,true_right_v,noise_left_p,noise_left_v] = add_noise_SS16(left_v,left_p,right_v,right_p,noise,steps)

% Expand the lottery space
true_left_p = repmat(left_p,1,steps);
true_left_v = repmat(left_v,1,steps);
true_right_p = repmat(right_p,1,steps);
true_right_v = repmat(right_v,1,steps);

% Add noise as quantiles
if noise ~= 0
    quantiles = norminv(linspace(1e-5,1-1e-5,steps),0,noise);
    quantiles = repmat(quantiles,size(true_left_p,1),1);
else
    quantiles = zeros(size(true_left_p));
end

% Add noise to lotteries
noise_left_p    = true_left_p + quantiles;
noise_left_v   = true_left_v + shuffle(quantiles);

% Reshape the lotteries and noise into vectors
true_left_p = true_left_p(:);
true_left_v = true_left_v(:);
true_right_p = true_right_p(:);
true_right_v = true_right_v(:);

noise_left_p = noise_left_p(:);
noise_left_v = noise_left_v(:);


end
