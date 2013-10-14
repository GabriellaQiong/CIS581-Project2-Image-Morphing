im1 = ones([50,50,3]);
im2 = zeros([50,50,3]);

im1_pts = [1,1; 10,15; 15,20; 45, 38];
im2_pts = [6,1; 10,15; 15,20; 45, 45]; 

tri = delaunay(im1_pts(:,1),im1_pts(:,2));                      
morphed_im = morph(im1, im2, im1_pts, im2_pts, tri, .3, .3);

if(size(morphed_im,3) ~= 3)
	fprintf('What happened to color?\n');
end

if(any(size(morphed_im) ~= [50,50,3]))
	fprintf('Something Wrong about the size of output image\n');
end

[a1_x,ax_x,ay_x,w_x] = est_tps(im1_pts, im2_pts(:,1));
[a1_y,ax_y,ay_y,w_y] = est_tps(im1_pts, im2_pts(:,2));

if(any(size(w_x) ~= [4,1]))
	fprintf('w from est_tps should be 4x1 for this instance \n');
end

if(numel(a1_x) ~= 1 || numel(ax_x) ~= 1 || numel(ay_x) ~= 1)
	fprintf('w from est_tps should be 4x1 for this instance \n');
end

morphed_im = morph_tps(im2, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, im1_pts, [150,200]);

if(any(size(morphed_im) ~= [150,200,3]))
	fprintf('Incorrect Size\n');
end


