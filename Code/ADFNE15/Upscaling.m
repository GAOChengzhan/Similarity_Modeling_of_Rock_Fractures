function out = Upscaling(in,mtd,up)
% Upscaling
% upscales "in" by method "mtd" to level "up"
%
% Usage...:
% out = Upscaling(in,mtd,up);
%
% Input...: in        (m,n)
%           mtd       harmonic,geometric,arithmetic (=else)
%           up        (1),number
% Output..: out       any
%
% Examples:
%{
out = Upscaling(rand(2^4,2^4),'geometric',2); % = 2x2 matrix
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

[m,n] = size(in);                                                               % size of input matrix
if (2^int32(log2(m)) ~= m) || (2^int32(log2(n)) ~= n)                           % m and n should be of type 2^x
    error('(mxn):m and n should be of: m=2^x,n=2^y');
end
if nargin < 3; up = 1; end                                                      % default final level
if nargin < 2; mtd = 'harmonic'; end                                            % default method
mtd = lower(mtd);
if (m <= up) || (n <= up)
    out = in;                                                                   % stops recursive call
else
    out = zeros(m/2,n/2);                                                       % initializes the output
    for i = 1:2:m-1                                                             % coarsening by factor of two
        for j = 1:2:n-1                                                         % ...also on other dimension
            cl = in(i:i+1,j:j+1);                                               % cell values
            switch mtd                                                          % selects upscaling method
                case {'harmonic','h'}
                    out(1+(i-1)/2,1+(j-1)/2) = harmmean(cl(:));                 % harmonic mean
                case {'geometric','g'}
                    out(1+(i-1)/2,1+(j-1)/2) = geomean(cl(:));                  % geometric mean
                otherwise
                    out(1+(i-1)/2,1+(j-1)/2) = mean(cl(:));                     % arithmetic mean
            end
        end
    end
    out = Upscaling(out,mtd,up);                                                % calls recursively
end
