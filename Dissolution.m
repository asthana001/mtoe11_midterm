clear all;
close all;
clc;

delta_t = 0.001; %time spacing
delta_x = 0.1; %grid spacing
delta_y = 0.1; %grid spacing
Nx = 200; %Number of points
Ny = Nx; %Length of Y = Length of X
spacing = 1.0; %Mesh Spacing for quiver plot
[X,Y] = meshgrid(1:spacing:Nx); %Creating mesh
t = 750; %Number of timesteps
c_cementite = 6.67; %Concentration of cementite
c_pearlite = 0.025; %Concentration of ferrite
d = 9.75e-11; %Diffusivity
vold = zeros(Nx,Ny); %Initialization of concentration array
v = zeros(Nx,Ny); %Initialization of concentration array (for updating the values)
H = zeros(Nx,Ny); %Initialization of array describing the horizontal component of flux
V = zeros(Nx,Ny); %Initialization of array describing the vertical component of flux
%% Initial Profile
for i=Nx/4:(3*Nx)/4
    for j=Ny/4:(3*Ny)/4
        v(i,j) = c_cementite;
    end
end
vold = v;
%%
%Calculation using diffusion equation using explicit scheme
for k=1:t %for loop for time evolution
    for i=2:Nx-1 %for loop for spatial evolution along x
        for j=2:Ny-1 %for loop for spatial evolution along y
            H(i,j) = (((vold(i,j+1)) -2*vold(i,j) + (vold(i,j-1)))/(delta_x*delta_x));
            V(i,j) = (((vold(i-1,j)) - 2*vold(i,j) + (vold(i+1,j)))/(delta_y*delta_y));
            v(i,j) = vold(i,j) + delta_t*(H(i,j)+V(i,j)); 
        end
    end
    vold = v;
    %[DX,DY] = gradient(v,spacing);
    %quiver(X,Y,DX,DY,1) %To create a vector plot
    %title ('time: ',delta_t*k)
    %xlim([0 200])
    %ylim([0 200])
    %xlabel('x-direction')
    %ylabel('y-direction')
    %drawnow
    %axis equal
    v_overtime(:,:,k) = v; %Collect the 2D matrices over time
end

%%
%Visualisation using contour plots
for k = 1:t    
    contourf(v_overtime(:,:,k))
    colorbar
    title ('time: ',delta_t*k)
    axis equal
    xlabel('x-direction')
    ylabel('y-direction')
    caxis ([0.0, 6.67])
    drawnow
end
