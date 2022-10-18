function ags = Angle(ags,lim)
% Angle
% projects the angles "ags" onto the limits "lim"
%
% Usage...:
% ags = Angle(ags,lim);
%
% Input...: ags       any,in degree
%           lim       (1),0|90|180|360
% Output..: ags       any,in degree
%
% Examples:
%{
ags = Angle([0,90,135,180,225,270,355,-10,-95,-180,-230,-365,723],360);
%   = 0  90  135  180  225  270  355  350  265  180  130  355  3
%}
%
% Alghalandis Discrete Fracture Network Engineering (ADFNE),*R1.5*
% Copyright (c) 2018 Alghalandis Computing @
% Author: Dr. Younes Fadakar Alghalandis
% (w) http://alghalandis.net      (e) alghalandis.net@gmail.com
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

switch lim
    case 0                                                                      % azimuth:[0..360) counterclockwise
        ags = mod(90-ags,360);
    case 90                                                                     % dip angles [0..90]
        ags = Angle(ags,360);                                                   % stage 1, [0..360)
        ags = mod(ags,180);                                                     % stage 2, [0..180)
        f = (ags > 90);
        ags(f) = 180-ags(f);                                                    % finally, [0..90]
    case 360                                                                    % direction angles [0..360)
        ags = mod(ags,360);                                                     % (-360..360)
        f = (ags < 0);
        ags(f) = 360+ags(f);                                                    % [0..360)
        ags(ags == 360) = 0;                                                    % replaces any 360 with 0
    otherwise                                                                   % direction i.e., 0==180
        f = (ags < 0) | (ags > 180);                                            % ...or strike
        ags(f) = abs(-(-abs(ags(f))+180));
        f = (ags > 90);
        ags(f) = 180-ags(f);                                                    % [0..180)
end
