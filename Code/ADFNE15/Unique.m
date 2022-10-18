function [out,ia,ic] = Unique(in,tol)
% Unique
% removes duplicates in "in" points,lines 2D|3D
%
% Usage...:
% [out,ia,ic] = Unique(in,tol);
%
% Input...: in        (n,2|3|4|6),points,lines 2D|3D
%           tol       (1),tolerance
% Output..: out       any,unique items
%           ia        any,indices
%           ic        any,indices
%
% Examples:
%{
pts = Unique(pts);
lns = Unique(lns);
%}
%
% Alghalandis Discrete Fracture Network Engineering (ADFNE),*R1.5*
% Copyright (c) 2018 Alghalandis Computing @
% Author: Dr. Younes Fadakar Alghalandis
% (w) http://alghalandis.net        (e) alghalandis.net@gmail.com
% All rights reserved.
%
% License.: ADFNE1.5_License.txt and at http://alghalandis.net/products/adfne/adfne15
%
% Citations:
% Fadakar-A Y, 2017, "ADFNE: Open source software for discrete fracture network
% engineering, two and three dimensional applications", Journal of Computers &
% Geosciences, 102:1-11.
%
% Fadakar-A Y, 2018, "DFNE Practices with ADFNE", Alghalandis Computing, Toronto, 
% Ontario, Canada, http://alghalandis.net, pp61.
%
% see more at: http://alghalandis.net/products/adfne
% Updated.: 2018-01-11

global Tolerance
if nargin < 2; tol = Tolerance; end                                             % default tolerance
k = size(in,2);
if (k > 2) && (mod(k,2) == 0)                                                   % 2D|3D lines
    k = 0.5*k;
    f = (sum(in(:,1:k).^2,2) > sum(in(:,k+1:end).^2,2));                        % sorts relative to the origin
    in(f,:) = [in(f,k+1:end),in(f,1:k)];
end
[~,ia,ic] = uniquetol(in,tol,'ByRow',true,'DataScale',1);                       % removes duplicates
ia = sort(ia);
out = in(ia,:);
