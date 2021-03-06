%% MAIN Program for PGD computational vademecum generation
%   Updated on: Oct. 8th, 2016
%   Author: Xi Zou
%           University of Pavia, Italy
%           Polytechnic University of Catalonia, Spain

%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.

close all; clear; clc;
warning('off','all')
non_intrusive = 0; % Change to 1 if you want to run non-intrusively
%% Data for 1D parametric Problem
% Range of parameters
E1_min = 1000; E1_max = 11000;
E2_min = 11000; E2_max = 21000;
% Determine size of 1D mesh
nel = 100;        % Number of elements
nnd = nel + 1;    % Number of nodes
% Compute necessary matrices for 1D problems
[P_1,M_1,Q_1] = compute_mtx(nel, E1_min, E1_max);
[P_2,M_2,Q_2] = compute_mtx(nel, E2_min, E2_max);

%% Data for 3D mechanical Problem
if non_intrusive == 1
    delete *.mtx
end
if not(exist('K_1_STIF1.mtx','file') && exist('K_2_STIF1.mtx','file'))
    [~,~] = system('abaqus job=K_1 input=K1 >K_1.log');
    [~,~] = system('abaqus job=K_2 input=K2 >K_2.log');
    delete K_1.* K_2.*
end

K_1 = load('K_1_STIF1.mtx'); K_1 = spconvert(K_1);
K_2 = load('K_2_STIF1.mtx'); K_2 = spconvert(K_2);

F_amp = 100;      % nodal load value
F_ = get_ld('model.inp',size(K_1,1),F_amp);

%% Loop control parameters
err = 1.0e-2; % error limit of Alternative direction
err_modes = 1.0e-3; % error limit between amplitudes of PGD modes
n = 10; % maximum modes to search
iter_max = 10; % maximum iterations for alternative direction

%% Preallocate memory for vademecum data
vm_U = zeros(size(F_));
vm_omg_1 = zeros(nnd,1);
vm_omg_2 = zeros(nnd,1);
vm_amp = zeros(1);

%% Loop for PGD mode search
for i=1:n
    % Initialization
    U = zeros(size(F_));
    omega_1 = ones(nnd,1);
    omega_2 = ones(nnd,1);
    amp = [0,0];

    P1 = omega_1'*P_1*omega_1; % X1 is a number while X_1 is a matrix
    M1 = omega_1'*M_1*omega_1;
    Q1 = Q_1'*omega_1;

    % Loop for alternative direction
    for iter=1:iter_max
        % Update U
        P2 = omega_2'*P_2*omega_2;
        M2 = omega_2'*M_2*omega_2;
        Q2 = Q_2'*omega_2;
        % Compute r.h.s
        P1k = omega_1'*P_1*vm_omg_1;
        P2k = omega_2'*P_2*vm_omg_2;
        M1k = omega_1'*M_1*vm_omg_1;
        M2k = omega_2'*M_2*vm_omg_2;
        R = (K_1*vm_U)*(P1k.*M2k)' + (K_2*vm_U)*(M1k.*P2k)';
        % Output parameters cannot be sparse matrix
        E1_tilde = full(P1.*M2);
        E2_tilde = full(M1.*P2);
        F_star = full(Q1.*Q2.*F_-R);

        if non_intrusive ==1
            U = call_abq(E1_tilde,E2_tilde,F_star);  % Non-intrusive
        else
            U = (E1_tilde.*K_1+E2_tilde*K_2)\F_star; % Intrusive
        end

        % Update omega_1
        K1 = U'*K_1*U;
        K2 = U'*K_2*U;
        F = U'*F_;      % F is a number while F_ is a vector
        % Compute r.h.s
        K1k = U'*K_1*vm_U;
        K2k = U'*K_2*vm_U;
        M2k = omega_2'*M_2*vm_omg_2;
        P2k = omega_2'*P_2*vm_omg_2;
        R = (P_1*vm_omg_1)*(K1k.*M2k)'+(M_1*vm_omg_1)*(K2k.*P2k)';

        omega_1 = (K1.*M2.*P_1+K2.*P2.*M_1)\(F.*Q2.*Q_1-R);

        % Update omega_2
        P1 = omega_1'*P_1*omega_1;
        M1 = omega_1'*M_1*omega_1;
        Q1 = Q_1'*omega_1;
        % Compute r.h.s
        K1k = U'*K_1*vm_U;
        K2k = U'*K_2*vm_U;
        P1k = omega_1'*P_1*vm_omg_1;
        M1k = omega_1'*M_1*vm_omg_1;
        R = (M_2*vm_omg_2)*(K1k.*P1k)'+(P_2*vm_omg_2)*(K2k.*M1k)';

        omega_2 = (K1.*P1.*M_2+K2.*M1.*P_2)\(F.*Q1.*Q_2-R);
        % Compute amplitude
        amp(2) = norm(U).*norm(omega_1).*norm(omega_2);

%         fprintf('%d.%d:\t\t%g\n', i, iter, amp(2));

        % Optional stopping criterion for alternative direction
        if iter>1 && abs(amp(2)-amp(1))/abs(amp(1))<err
            fprintf('%d.%d:\t\t%g\t\tConverged!\n', i, iter, amp(2));
            break
        end
        % Update amplitude
        amp(1) = amp(2);
    end

    % Save new mode to vademecum
    vm_U(:,i) = full(U);
    vm_omg_1(:,i) = full(omega_1);
    vm_omg_2(:,i) = full(omega_2);
    vm_amp(i) = amp(2);

    % Optional stopping criterion for mode search
    if i>1 && vm_amp(i)/vm_amp(1)<err_modes
        break
    end
end

%% Save vademecum to file
save('vademecum.mat','U','nel', ...
    'E1_min','E1_max','E2_min','E2_max', ...
    'vm_U','vm_omg_1','vm_omg_2','vm_amp')

disp DONE!
