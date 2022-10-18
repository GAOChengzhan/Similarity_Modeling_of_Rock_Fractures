function tgt = setstructfields(tgt,upd)
names = fieldnames(upd);
for i = 1:numel(names)
    tgt.(names{i}) = upd.(names{i});
end
