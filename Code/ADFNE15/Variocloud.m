function [d,g,v] = Variocloud(pts,vls,d,draw)
% Variocloud
% computes and draws variogram cloud of points "pts" with values "vls"
%
% Usage...:
% [d,g,v] = Variocloud(pts,vrl,d,draw);
%
% Input...: pts       (m,2|3),points 2D|3D
%           vls       (m,1)
%           d         (m,m)
%           draw      (1),boolean
% Output..: d         distances
%           g         gammas
%           v         variance
%
% Examples:
%{
[d,g,v] = Variocloud(rand(10,2),rand(10,1),[],true);
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
% Updated.: 2018-01-01

if nargin < 4; draw = false; end
[m,n] = size(pts);                                                              % number of points, dimension
if (nargin < 3) || isempty(d)
    s = zeros(m,m);
    for j = 1:n
        [a,b] = meshgrid(pts(:,j));                                             % repeats a dimension (axis)
        s = s+(b-a).^2;                                                         % sum of diff. all axes
    end
    d = sqrt(s);                                                                % distances
end
[a,b] = meshgrid(vls);                                                          % repeats values as matrix
g = 0.5*(b-a).^2;                                                               % gamma
d = Flatri(d);                                                                  % lower triangle part, flattened
g = Flatri(g);
v = var(vls);                                                                   % variance of values
if draw
    cla;
    plot(d,g,'.');                                                              % plots as 2d points
    xlabel('d'); ylabel('gamma'); axis square; box on;                          % axes' labels, etc.
	title('Variogram Cloud'); Axes(0,'p',5);                                    % ...expands axes by 5%
end
