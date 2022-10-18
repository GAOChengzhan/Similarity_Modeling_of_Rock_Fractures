function ots = Sort(pts,dir)
% Sort
% sorts points 'pts' in topological order, 2D|3D
%
% Usage...:
% ots = Sort(pts,dir);
%
% Input...: pts       (n,2|3),points 2D|3D
%           dir       (4|6),line
% Output..: ots       (n,2|3),points 2D|3D sorted
%
% Examples:
%{
pts = Sort(rand(10,2),nan); % = topologically sorted points
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

if isnan(dir)                                                                   % if nan
    [~,j] = max(pdist(pts,'euclidean'));                                        % distances
    [I,J] = find(tril(ones(size(pts,1)),-1));
    dir = [pts(I(j),:),pts(J(j),:)];
end
[~,j] = sort(pdist2(Snap(pts,dir,Inf),dir(1:2),'euclidean'));                   % sorts topologically
ots = pts(j,:);
