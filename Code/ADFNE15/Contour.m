function Contour(pts,vls,k,filled,mtd,varargin)
% Contour
% draws contour graph based on points "pts" with values "vls"
%
% Usage...:
% Contour(pts,vls,k,filled,mtd,varargin);
%
% Input...: pts       (n,2),points
%           vls       (n),values at points
%           k         (1),meshing number
%           filled    (1),boolean,if true, filled contours
%           mtd       (1),string,interpolation method 'idw' or else
%           varargin  any,for contour function
%
% Examples:
%{
Contour(rand(10,2),rand(10,1),20,true,'idw');
Contour(rand(10,2),rand(10,1),20,true,'idw','linewidth',2,'linestyle',':');
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

if nargin < 5; mtd = 'idw'; end                                                 % interpolation method
if nargin < 4; filled = true; end                                               % if true, invokes 'contourf'
if nargin < 3; k = 20; end                                                      % number of contours
p = min(pts);                                                                   % min of all points
q = max(pts);                                                                   % max of all points
[x,y] = meshgrid(linspace(p(1),q(1),k),linspace(p(2),q(2),k));                  % mesh for interpolation
switch lower(mtd)                                                               % selects interpolation method
    case 'idw'                                                                  % inverse distance weighted
        v = reshape(IDW(pts(:,1:2),vls(:),[x(:),y(:)]),size(x));
    otherwise                                                                   % else
        v = griddata(pts(:,1),pts(:,2),vls(:),x,y,mtd);
end
if filled
    contourf(x,y,v,varargin{:});                                                % filled contours
else
    contour(x,y,v,varargin{:});                                                 % only contour curves
end
