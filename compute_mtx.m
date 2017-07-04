function [P,M,Q] = compute_mtx(nel,x_min,x_max)
%COMPUTE_MTX Generate matrices for 1D parametric problem.
%   Works only for 1D mesh with linear elements.
%   SYNOPOSIS:  [P,M,Q] = compute_mtx(nel,x_min,x_max);
%   INPUT:   nel   : Number of elements, integer
%            x_min : Lower bound of parameter, scalar
%            x_max : Upper bound of parameter, scalar
%   OUTPUT:  P : Mass-like matrix, [(nel+1)*(nel+1)] matrix
%            M : Mass matrix, [(nel+1)*(nel+1)] matrix
%            Q : Load-like vector, [(nel+1)*1] vector
%   Updated on: Oct. 8st, 2016
%   Author: Xi Zou
%           University of Pavia, Italy
%           Polytechnic University of Catalonia, Spain

%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.

delta = (x_max-x_min)/nel;

i = [1:nel+1,1:nel,2:nel+1];
j = [1:nel+1,2:nel+1,1:nel];

v_P = delta/12 * [4*x_min+delta,8*(x_min+delta*(1:1:nel-1)), ...
                4*x_max-delta,2*x_min-delta+2*delta*(1:1:nel), ...
                2*x_min-delta+2*delta*(1:1:nel)];
v_M = delta/6 * [2,2*2.*ones(1,nel-1),2,ones(1,2*nel)];
v_Q = delta/2 * [1,2*ones(1,nel-1),1];

P = sparse(i,j,v_P);
M = sparse(i,j,v_M);
% Q = sparse(v_Q');
Q = v_Q';