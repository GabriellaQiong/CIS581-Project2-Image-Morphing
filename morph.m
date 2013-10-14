function morphed_im = morph(im1, im2, im1_pts, im2_pts, tri, warp_frac, dissolve_frac, verbose)
% MORPH provides the morphing result of the two input images, which
% represent one kind of intermediate state

% Written by Qiong Wang at University of Pennsylvania
% Oct. 9th, 2013

if nargin < 8
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

% Initialize
tri_num    = size(tri,1);
im1_warp   = zeros(nr, nc, 3);
im2_warp   = zeros(nr, nc, 3);
sub_array  = [repmat(1:nc, 1, nr); reshape(repmat(1:nr, nc, 1), [1 nr*nc]); ones(1, nr*nc)];
ps_1       = zeros(3, nr * nc);
ps_2       = zeros(3, nr * nc);

% Intermediate points
imwarp_pts = (1 - warp_frac) * im1_pts + warp_frac * im2_pts;

% Loop for each triangle to calculate the transform matrix
row_ind = mytsearch(imwarp_pts(:,1), imwarp_pts(:,2), tri, sub_array(1,:)', sub_array(2,:)');
for i = 1 : tri_num
    tf_warp               = [[imwarp_pts(tri(i, 1), :); imwarp_pts(tri(i, 2), :); imwarp_pts(tri(i, 3),:)]'; ones(1,3)];
    tf_1                  = [[im1_pts(tri(i, 1), :); im1_pts(tri(i, 2), :); im1_pts(tri(i, 3), :)]'; ones(1,3)] / tf_warp;
    tf_2                  = [[im2_pts(tri(i, 1), :); im2_pts(tri(i, 2), :); im2_pts(tri(i, 3), :)]'; ones(1,3)] / tf_warp;
    ps_1(:, row_ind == i) = pixel_limit(tf_1 * sub_array(:, row_ind == i), nr, nc);
    ps_2(:, row_ind == i) = pixel_limit(tf_2 * sub_array(:, row_ind == i), nr, nc);
end

% Loop for each pixel
for i = 1 : nr*nc
   if isnan(row_ind(i))
       continue;
   end
   im1_warp(sub_array(2,i), sub_array(1,i), :) = im1_pad(ps_1(2, i), ps_1(1, i), :);
   im2_warp(sub_array(2,i), sub_array(1,i), :) = im2_pad(ps_2(2, i), ps_2(1, i), :);
end

% Dissolve two warpped images
morphed_im = (1-dissolve_frac) * im1_warp + dissolve_frac * im2_warp;
morphed_im = uint8(morphed_im);

if verbose
    figure();imshow(morphed_im); axis image; title('Image Morphing');
end

end