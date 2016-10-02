function F = get_ld(fName,len,val)
%GET_LD Obtain load data from Abaqus .inp file.
%   Works only for 3D mesh.
%   SYNOPOSIS:  F = get_ld(fName,len,val);
%   INPUT:   fName : File name of .inp file, including extension, string
%            len   : Length of the vector, integer
%            val   : Load value on each node, scalar
%   OUTPUT:  F : Load vector, [len*1] vector
%   DESCRIPTION:
%           Node number of the model should be one third of len.
%           Node number of nodes (nnd) carrying loads will be obtained from
%           node set nSet-Load. Each node in this set carries a point load
%           in z direction with value equals to val.
%   Updated on: Oct. 1st, 2016
%   Author: Xi Zou
%           University of Pavia, Italy
%           Polytechnic University of Catalunya, Spain

%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.

s = fileread(fName);
s = textscan(s,'%s','Delimiter','','EndOfLine','');
s = char(s{1});

Tag = '*Nset, nset=nSet-Load';
st = strfind(s,Tag)+length(Tag)+2;
s = s(st:end);

Tag = '*Nset, nset=nSet-Fixed';
ed = strfind(s,Tag);
s = s(1:ed-2);

s = regexprep(s,'\n',',');
sdata = regexp(s,',','split');
nid = str2double(sdata);
nnd = length(nid);

F = zeros(len,1);
nid = 3 * nid;
F(nid) = val/nnd * ones(nnd,1);