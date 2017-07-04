%% Program for PGD online plotting
%   Updated on: Oct. 8th, 2016
%   Author: Xi Zou
%           University of Pavia, Italy
%           Polytechnic University of Catalonia, Spain

%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.

close all; clear; clc;

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
semilogy(vm_amp,'o-','MarkerFaceColor','r');
xlabel('Mode')
ylabel('Amplitude')
title('PGD modes')

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

figure('Position',[100,100,1200,300]);
subplot(131)
surf(x,y,z1,sp{:});
xlabel('E_1 [MPa]')
ylabel('E_2 [MPa]')
zlabel('u_x-PGD [mm]')
title(['U_x for Node ' num2str(nid)])

subplot(132)
surf(x,y,z2,sp{:});
xlabel('E_1 [MPa]')
ylabel('E_2 [MPa]')
zlabel('u_y-PGD [mm]')
title(['U_y for Node ' num2str(nid)])

subplot(133)
surf(x,y,z3,sp{:});
xlabel('E_1 [MPa]')
ylabel('E_2 [MPa]')
zlabel('u_z-PGD [mm]')
title(['U_z for Node ' num2str(nid)])
