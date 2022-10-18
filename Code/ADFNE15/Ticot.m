function Ticot(msg)
% Ticot
% manages timing
%
% Usage...:
% Ticot(msg);
%
% Input...: msg       (1),string
%
% Examples:
%{
Ticot('Graphing');
Ticot; % should be used always in pairs
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

global Times Messages History Silent                                            % global defaults
ofs = length(Times);
if nargin == 1
    if ~Silent
        fprintf([repmat(' ',1,4*ofs),'%s...\n'],msg);                           % displays message
    end
    Messages{end+1} = msg;                                                      % stores the message
    Times{end+1} = tic;                                                         % stores the time
else
    dt = toc(Times{end});                                                       % computes the elapsed time
    msg = [repmat(' ',1,4*(ofs-1)),'...',Messages{end}];
    if ~Silent
        fprintf([msg,repelem('.',1,60-length(msg)),'<Elapsed Time: %s>\n'],...  % displays message
            Convert('clock',dt));
    end
    nxt = repelem('@',length(Times) > 1,1);
    History{end+1,1} = [{[nxt,Messages{end}]},Convert('clock',dt)];             % stores all in history
    Times(end) = '';
    Messages(end) = '';                                                         % removes last time
end                                                                             % removes last message
