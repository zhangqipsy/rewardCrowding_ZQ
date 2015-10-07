function new = updateStruct(old, new)
    % update the Sturcture with new field values

    fNames=fieldnames(old);
    for i=1:length(fNames)
        if isstruct(old.(fNames{i}))
            % struct within a struct; we need to recurse
            % Oh I hate recursion
            updateStruct(new.(fNames{i}), old.(fNames{i}));
        else
            % only update when the old one exists
            if isfield(old, fNames{i})
            new = setfield(new, fNames{i}, getfield(old, fNames{i}));
        else
            error('updateStruct:nonExistentField', 'Trying to update a non-existent field!');
        end
    end
