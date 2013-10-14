function morphed_im = morph_tps_wrapper(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac,verbose)
% MORPH_TPS_WRAPPER provides the morphing result of the two input images
% with thin-plate-spline method by building the TPS model.

% Written by Qiong Wang at University of Pennsylvania
% Oct. 10th, 2013

if nargin < 7
   verbose = false; 
end

% Check whether the number of control points in both images the same
assert(size(im1_pts, 1) == size(im2_pts, 1),'Control points in two images should be the same amount!');

% Pad images at the largest extent if they are not padded
[nr1, nc1, ~] = size(im1);
[nr2, nc2, ~] = size(im2);
if nr1 == nr2 && nc1 == nc2
    nr = nr1;
    nc = nc1;
    im1_pad = im1;
    im2_pad = im2;
else
    nr = max(nr1, nr2); 
    nc = max(nc1, nc2);
    im1_pad = padarray(im1, [nr-nr1, nc-nc1], 'replicate', 'post');
    im2_pad = padarray(im2, [nr-nr2, nc-nc2], 'replicate', 'post');
end

% Intermediate points
imwarp_pts = (1 - warp_frac) * im1_pts + warp_frac * im2_pts;

% TPS model computation
[a1_x,ax_x,ay_x,w_x] = est_tps(imwarp_pts, im1_pts(:,1));
[a1_y,ax_y,ay_y,w_y] = est_tps(imwarp_pts, im1_pts(:,2));
im1_warp = morph_tps(im1_pad, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, imwarp_pts, [nr, nc]);
[a1_x,ax_x,ay_x,w_x] = est_tps(imwarp_pts, im2_pts(:,1));
[a1_y,ax_y,ay_y,w_y] = est_tps(imwarp_pts, im2_pts(:,2));
im2_warp = morph_tps(im2_pad, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, imwarp_pts, [nr, nc]);

% Dissolve two warpped images
morphed_im = (1-dissolve_frac) * im1_warp + dissolve_frac * im2_warp;
morphed_im = uint8(morphed_im);

if verbose
    figure();imshow(morphed_im); axis image; title('Image Morphing with TPS');
end

end