function lts = Length(in)
% Length
% calculates lengths for "in", lines|polygons, 2D|3D
%
% Usage...:
% lts = Length(in);
%
% Input...: in        (n,4|6|cell),lines,polygons
% Output..: lts       (n)
%
% Examples:
%{
lts = Length(rand(10,4)); % 2d lines
lts = Length(rand(10,6)); % 3d lines
lts = Length(Field(DFN('dim',3),'Poly')); % 3d polygons
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

if iscell(in)                                                                   % 3D polygons
    rys = Ray(in);                                                              % rays from center of polygons
    lts = arrayfun(@(i)2*mean(Length(rys{i})),1:length(in),...                  % lengths of polygons
        'UniformOutput',true)';
else
    k = size(in,2)/2;                                                           % k 2:2D|3:3D lines
    lts = sqrt(sum((in(:,k+1:end)-in(:,1:k)).^2,2));                            % lengths of lines
end
