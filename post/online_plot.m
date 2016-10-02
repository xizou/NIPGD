close all; clear; clc;
%% Program for PGD online plotting
load ../vademecum.mat

% Label of querying node
nid = 100;

% Shape functions for parameters
N1 = @(x) shape_func(x, nel, E1_min, E1_max);
N2 = @(x) shape_func(x, nel, E2_min, E2_max);

% Displacement in PGD separated representation
U_PGD = @(omg1,omg2) vm_U * ...
            ((N1(omg1)'*vm_omg_1) .* (N2(omg2)'*vm_omg_2))';
%% Plots

% Mode-amplitude curve
figure;
vm_amp = vm_amp/vm_amp(1);
semilogy(vm_amp,'o-','MarkerEdgeColor','r');
xlabel('Mode')
ylabel('Amplitude')

% Online computation of values for surface plot
x = linspace(E1_min,E1_max);
y = linspace(E2_min,E2_max);
z1 = zeros(numel(y),numel(x));
z2 = zeros(numel(y),numel(x));
z3 = zeros(numel(y),numel(x));

for i=1:numel(x)
    for j=1:numel(y)
        U=U_PGD(x(i),y(j));
        z1(j,i) = U((nid-1)*3+1);
        z2(j,i) = U((nid-1)*3+2);
        z3(j,i) = U((nid-1)*3+3);
    end
end
% Online plots for displacement components of Node nid.
% sp = {'EdgeColor','interp','FaceColor','interp'};
sp = {'EdgeColor','flat'};

figure;
surf(x,y,z1,sp{:});
xlabel('E_1 [MPa]')
ylabel('E_2 [MPa]')
zlabel('u_x-PGD [mm]')
title(['Displacement in x direction on Node ' num2str(nid)])

figure;
surf(x,y,z2,sp{:});
xlabel('E_1 [MPa]')
ylabel('E_2 [MPa]')
zlabel('u_y-PGD [mm]')
title(['Displacement in y direction on Node ' num2str(nid)])

figure;
surf(x,y,z3,sp{:});
xlabel('E_1 [MPa]')
ylabel('E_2 [MPa]')
zlabel('u_z-PGD [mm]')
title(['Displacement in z direction on Node ' num2str(nid)])
