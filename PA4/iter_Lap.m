set(0,'DefaultFigureWindowStyle','docked')
%dimensions and variables:
Lx =1;
Ly =1;
Nx = 100;
Ny = 100;

%loop variables

ni = 10000;
eps = 1.e-6;
dx = Lx/Nx;
dy = Ly/Ny;

nx = Nx+1;
ny = Ny+1;

%gridpoint indices:
i_x = 2:nx-1;
i_y = 2:ny-1;

% x=(0:Nx)*dx;
% y = (0:Ny)*dy;

% boundary conditions and setup V
V = zeros(nx,ny);

V(:,1) = 0;%bottom
V(1,:) = 1;%left
V(:,ny) = 0;%4*x.*(1-x);%top
V(nx,:) = 0;%right

V_prev = V;
error = 2*eps;
numloop=0;

while (error > eps)
    numloop = numloop+1;
    
    V(i_x,i_y) = 0.25*(V(i_x+1,i_y)+V(i_x-1,i_y)...
        +V(i_x,i_y+1)+V(i_x,i_y-1));
    V(20,10:90) =0;
    %B = imboxfilt(V,3);
    error = max(abs(V(:)-V_prev(:)));
%     if mod(numloop,50) == 0
%         surf(V')
%         pause(0.01)
%     end
    V_prev = V;
end
figure
%B = imboxfilt(V,3);
surf(V')
% figure

%surf(B')
fprintf("\n numloop = %g \n",numloop);
[Ex,Ey] = gradient(V);

figure
quiver(-Ey',-Ex',1)