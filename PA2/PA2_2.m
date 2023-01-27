% This example shows how to calculate and plot both the
% fundamental TE and TM eigenmodes of an example 3-layer ridge
% waveguide using the full-vector eigenmode solver.  
clear all
set(0,'defaultaxesfontsize',20)
set(0,'DefaultFigureWindowStyle','docked')
set(0, 'DefaultLineLineWidth',2)
set(0,'Defaultaxeslinewidth',2)
set(0,'DefaultFigureWindowStyle','docked')
% Refractive indices:
n1 = 3.34;          % Lower cladding
n2 = 3.44;          % Core
n3 = 1.00;          % Upper cladding (air)

% Layer heights:
h1 = 2.0;           % Lower cladding
h2 = 1.3;           % Core thickness
h3 = 0.5;           % Upper cladding

% Horizontal dimensions:
rh = 1.1;           % Ridge height
rw = linspace(0.325,1,10);           % Ridge half-width
side = 1.5;         % Space on side

% Grid size:
dx = 0.0125*8;        % grid size (horizontal)
dy = 0.0125*8;        % grid size (vertical)

lambda = 1.55;      % vacuum wavelength
nmodes = 1;         % number of modes to compute
steps =10;
neff=[];

for j=1:steps
    [x,y,xc,yc,nx,ny,eps,edges] = waveguidemesh([n1,n2,n3],[h1,h2,h3], ...
                                                rh,rw(j),side,dx,dy); 
    
    % First consider the fundamental TE mode:
    
    [Hx,Hy,neff(j)] = wgmodes(lambda,n2,nmodes,dx,dy,eps,'000A');
    
    fprintf(1,'neff = %.6f\n',neff(j));
    %for i=1:nmodes
        figure('name',sprintf('TE Mode step:%d',j));
        subplot(1,2,1);
        contourmode(x,y,Hx);
        title('Hx (TE mode)'); xlabel('x'); ylabel('y');
        for v = edges, line(v{:}); end
        subplot(1,2,2);
        contourmode(x,y,Hy);
        title('Hy (TE mode)'); xlabel('x'); ylabel('y'); 
        for v = edges, line(v{:}); end
    %end
end
plot(linspace(1,10,10),neff)
title('Neff');
%Next consider the fundamental TM mode
%(same calculation, but with opposite symmetry)

%[Hx,Hy,neff] = wgmodes(lambda,n2,nmodes,dx,dy,eps,'000S');

% fprintf(1,'neff = %.6f\n',neff);
% for i=1:nmodes
%     figure(2);
%     subplot(1,2,1);
%     contourmode(x,y,Hx(:,:,i));
%     title('Hx (TM mode)'); xlabel('x'); ylabel('y'); 
%     for v = edges, line(v{:}); end
%     
%     subplot(1,2,2);
%     contourmode(x,y,Hy(:,:,i));
%     title('Hy (TM mode)'); xlabel('x'); ylabel('y'); 
%     for v = edges, line(v{:}); end
% end