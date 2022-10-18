function pvs = IDW(rts,rvs,pts)
% IDW
% returns IDW interpolation for points 'pts' on reference 'rts', values 'rvs'
%
% Usage...:
% pvs = IDW(rts,rvs,pts);
%
% Input...: rts       (n,k),reference points
%           rvs       (n),reference values
%           pts       (m,k),target points
% Output..: pvs       (m),interpolations
%
% Examples:
%{
pvs = IDW(rand(3,2),rand(3,1),rand(10,2));
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

d = pdist2(rts,pts);                                                            % distances between point sets
pvs = sum(rvs./d.^2)./sum(1./d.^2);                                             % inverse distance weighted
