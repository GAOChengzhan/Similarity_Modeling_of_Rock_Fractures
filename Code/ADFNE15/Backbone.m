function dfn = Backbone(dfn,tol)
% Backbone
% extracts backbone (skeleton) structure from dfn, 2D|3D
%
% Usage...:
% dfn = Backbone(dfn,tol);
%
% Input...: dfn       struct,fields:pip etc.
%           tol       (1),tolerance
% Output..: dfn       strcut,bbn field added
%
% Examples:
%{
dfn = Backbone(Pipe(be,dfn,'cnt')); % see Pipe function for details
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

global Tolerance Report
if ~isfield(dfn,'pip') || ~dfn.pip.Percolate; return; end                       % if no pip, exit
Ticot('Extracting Backbone');                                                   % initialize the timing
if nargin < 2; tol = Tolerance; end                                             % default tolerance value
lns = dfn.pip.Pipe;                                                             % pipes as lines
be = (dfn.pip.Type ~= 0);                                                       % boundary elements
b = false(size(lns,1),1);                                                       % initialize the mask for all lines
p = 0;                                                                          % stores number of isolated lines
while true                                                                      % infinitely iterative test
    f = (~b | be);                                                              % takes care of boundary elements
    c = Isolated(lns(f,:),tol);                                                 % isolation test
    q = sum(c);                                                                 % number of isolated lines
    if p == q; break; else; p = q; end                                          % finish if all done!
    b(f) = c;                                                                   % updates the mask
end
b = ~b;                                                                         % inverse of the mask
if any(b)                                                                       % if any backbone found
    dfn.bbn.Backbone = lns(b,:);                                                % the resulting backbone
    dfn.bbn.B = b;                                                              % the mask
    if Report; Display('Backbone#',size(dfn.bbn.Backbone,1)); end               % display information
end
Ticot;                                                                          % ends timing
