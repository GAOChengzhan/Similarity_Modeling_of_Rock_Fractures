function s = pad(s,n,side)
switch side
    case 'left'
        s = [repelem(' ',1,n),s];
end
