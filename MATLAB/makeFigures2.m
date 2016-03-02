% makeFigures2
%%
L = 64;
r1 = L/2;
r1
r2 = L/4;

X = zeros(L, L);
N = length(-L:L);
x = -L:L;
y = -L:L;

[xg, yg] = meshgrid(x,y);

r = sqrt(xg.^2 + yg.^2);
Xon = zeros(N,N);
Xon(r > L) = 1;
Xon(r > L-1) = -1;
Xon(r < L-2) = 0;
Xon(r < r2) = -1;

h_ax = subplot(1,2,2);
imagesc(Xon); axis equal tight;
set(h_ax, 'visible', 'off')
ticksOff;
colormap('gray');
caxis([-1, 1]);



