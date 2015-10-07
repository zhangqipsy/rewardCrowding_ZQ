function new = updateStruct(old, new)
    % update the Sturcture with new field values

    fNames=fieldnames(old);
    for i=1:length(fNames)
        if isstruct(old.(fNames{i}))
            % struct within a struct; we need to recurse
            % Oh I hate recursion
            updateStruct(new.(fNames{i}), old.(fNames{i}));
        else
            new = setfield(new, fNames{i}, getfield(old, fNames{i}));
        end
    end
