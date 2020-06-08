


function [grid,grid_pc] = get_loss_ptprob_SnS(alphas,gammas,n_iter,sigma,left_v,left_p,right_v,right_p,left,right)

grid    = nan(n_iter,n_iter);

% Add noise 
[true_left_p,true_left_v,true_right_p,true_right_v,noise_left_p,noise_left_v] = add_noise_SnS(left_v,left_p,right_v,right_p,sigma,100);
noise_left_p = min(1,noise_left_p);
noise_left_p = max(0,noise_left_p);

% Search over grid
for i = 1:n_iter % gamma (y-axis)
    for j = 1:n_iter % alpha (x-axis)
        [this_mean] = get_point_loss_SnS(true_left_v,true_left_p,true_right_v,true_right_p,true_left_v .* true_left_p,true_right_v .* true_right_p,noise_left_v,noise_left_p,alphas(j),gammas(i),sigma);
        grid(i,j) = this_mean;
    end
end

end