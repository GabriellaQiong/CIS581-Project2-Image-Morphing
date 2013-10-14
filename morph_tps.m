function morphed_im = morph_tps(im_source, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, ctr_pts, sz)
% MORPH_TPS_WRAPPER provides the morphing result of the two input images
% with TPS parameters.

% Written by Qiong Wang at University of Pennsylvania
% Oct. 10th, 2013

% Pad the image if it is not paded
nr            = sz(1);
nc            = sz(2);
[nrs, ncs, ~] = size(im_source);
assert(nr >= nrs || nc >= ncs, 'The desired size should be at least the same size as the source image');
if nr == nrs && nc == ncs
    im_pad = im_source;
else
    im_pad = padarray(im_source, [nr-nrs, nc-ncs], 'replicate', 'post');
end

% Initialize
p          = [zeros(2, nr * nc); ones(1, nr * nc)];
pts_num    = size(ctr_pts, 1);
sub_array  = [repmat(1:nc, 1, nr); reshape(repmat(1:nr, nc, 1), [1 nr*nc]);];
morphed_im = zeros(nr, nc, 3);

% TPS model computation
mat_diff   = @(vector, ctrl_pts_col) bsxfun(@minus, ctrl_pts_col, repmat(vector, pts_num, 1));
r_sqr      = mat_diff(sub_array(1,:), ctr_pts(:,1)).^2 + mat_diff(sub_array(2,:), ctr_pts(:,2)).^2 + eps;
U          = -r_sqr.* log(r_sqr);
p(1:2, :)  = bsxfun(@plus, [a1_x ;a1_y], [ax_x, ay_x; ax_y, ay_y] * sub_array + [w_x'; w_y'] * U);
p          = pixel_limit(p, nr, nc);

% Loop for each pixel
for i = 1 : nr*nc
    morphed_im(sub_array(2,i), sub_array(1,i), :) = im_pad(p(2, i), p(1, i), :);
end

end