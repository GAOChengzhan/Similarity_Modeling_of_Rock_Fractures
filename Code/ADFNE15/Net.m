function pts = Net(x,y,varargin)
% Net
% creates meshgrid in point format
%
% Usage...:
% pts = Net(x,y,varargin);
%
% Input...: x         (n),x range
%           y         (m),y range
%           varargin  {...}
% Output..: pts       points
%
% Examples:
%{
pts = Net(1:10,3:4);
pts = Net(1:10,3:4,6:7);
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

if isempty(varargin)                                                            % 2d case
    [x,y] = meshgrid(x,y);                                                      % creates meshgrid
    pts = [x(:),y(:)];                                                          % as 2d points
else                                                                            % 3d case
    [x,y,z] = meshgrid(x,y,varargin{1});                                        % creates meshgrid
    pts = [x(:),y(:),z(:)];                                                     % as 3d points
end
