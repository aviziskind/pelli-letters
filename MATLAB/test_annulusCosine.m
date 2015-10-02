
M = 200;
N = 200;

C = [floor(M/2), floor(N/2)];

x = [1:M] - C(1);
y = [1:N] - C(2);

nMult = 100;
dx = 1/nMult;

x_fine = [1:dx:M] - C(1);
y_fine = [1:dx:N] - C(2);

[xg, yg] = meshgrid(x,y);
[xg_fine, yg_fine] = meshgrid(x_fine,y_fine);

%%

r = sqrt(xg.^2 + yg.^2);
r_fine = sqrt(xg_fine.^2 + yg_fine.^2);


mask = zeros(M,N);
mask_fine = zeros(M,N);

mask(r <= 2) = 1;

r_fine_av = zeros(M,N);

% for i = 1:M
    idx_x_closest = binarySearch(x, x_fine);
    idx_y_closest = binarySearch(y, y_fine);
    
    [~, idx_x] = uniqueList(idx_x_closest);
    [~, idx_y] = uniqueList(idx_y_closest);
    
    %%
        
r0 = M*1/3;
w = 1/sqrt(2);
    
mask_fine = zeros(M,N);
mask_fine2 = zeros(M,N);
mask_fine3 = zeros(M,N);

mean_r_fine = zeros(M,N);
for i = 1:M,
    for j = 1:N
        vals = r_fine(idx_x{i}, idx_y{j});
        mean_r_fine(i,j) = mean(vals(:));
        mask_fine(i,j) = nnz(vals(:) < r0) / nnz(vals(:));
        mask_fine2(i,j) = cosineDecay(mean_r_fine(i,j), r0-w, r0+w);
        mask_fine3(i,j) = cosineDecay(r(i,j), r0-w, r0+w);
    end
end
        
%%
figure(55); clf;
imagesc( mask_fine3 ); 
colormap('gray'); axis equal tight;
colorbar;


%%
figure(56); clf; hold on; box on;
plot(mean_r_fine(:), mask_fine(:), '.');
plot(mean_r_fine(:), mask_fine2(:), 'r.');
plot(mean_r_fine(:), mask_fine3(:), 'g.');

xlim([r0-3, r0+3]);

%%


x = linspace(0, 10, 200);
x1 = 2;
x2 = 9;
idx_left = x < x1;
idx_mid = ibetween(x, x1, x2);
idx_right = x > x2;
y(idx_left) = 1;
y(idx_right) = 0;
y(idx_mid) = 0.5;



figure(65);
plot(x,y, '.-');

%%
x = linspace(0, pi, 200);
x1 = pi/4;
x2 = pi/2;
idx_left = x < x1;
idx_mid = ibetween(x, x1, x2);
idx_right = x > x2;
y(idx_left) = 0;
y(idx_right) = 1;
y(idx_mid) = cos( pi/2 * log2(2*x(idx_mid)/pi));

% y(idx_mid) = cos(  (x(idx_mid)-x1)/(x2-x1)*pi );


figure(65);
plot(x,y, '.-');




%%


nMid_x = floor(N/2)+1;
nMid_y = floor(N/2)+1;

cyc_per_pix_range = 1./[6, 3]; 

cyc_per_image_range = 1./ [M, N]; 

cyc_per_image_range = [2,4];


mask = zeros(M, N);
[x_idx, y_idx] = meshgrid(1:N, 1:M);
r = sqrt( (x_idx - nMid_x) .^2 + (y_idx - nMid_y) .^2 );
