function N = shape_func(x, nel, x_min, x_max)
%SHAPE_FUNC Generate shape function vector for 1D parametric problem.
%   Works only for 1D mesh with linear elements.
%   SYNOPOSIS:  N = shape_func(x, nel, x_min, x_max);
%   INPUT:   x     : Querying location, scalar
%            nel   : Number of elements, integer
%            x_min : Lower bound of parameter, scalar
%            x_max : Upper bound of parameter, scalar
%   OUTPUT:  N : Shape function vector, [(nel+1)*1] vector
%   Updated on: Oct. 1st, 2016
%   Author: Xi Zou
%           University of Pavia, Italy
%           Polytechnic University of Catalunya, Spain

%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.

delta = (x_max-x_min)/nel;
N = zeros(nel+1,1);

k = floor((x-x_min)/delta+1);
xk = x_min + (k-1)*delta;
N(k)=(xk+delta-x)/delta;

if k<=nel
    N(k+1)=(x-xk)/delta;
end
