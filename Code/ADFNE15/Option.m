function opt = Option(opt,varargin)
% Option
% helper function for 'varargin' in functions
%
% Usage...:
% opt = Option(opt,varargin);
%
% Input...: opt       any
%           varargin  any
% Output..: opt       any
%
% Examples:
%{
opt = Option(varargin,'a',1);
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

if isempty(squeeze(opt))
    opt = Convert('Struct',varargin{:});                                        % if 'opt' was empty
else
    if ~ischar(opt{1}); opt = [{'in'},opt]; end                                 % if first item is a value
    opt = setstructfields(Convert('Struct',varargin{:}),Convert('Struct',...    % updates
	    opt{:}));
end
try opt.('facecolor') = opt.fc; catch; end                                      % for convenience
try opt.('edgecolor') = opt.ec; catch; end
try opt.('facealpha') = opt.fa; catch; end
try opt.('radius') = opt.r; catch; end
try opt.('linewidth') = opt.lw; catch; end
try opt.('center') = opt.cnt; catch; end
end
