function targetStruct = updateStruct(partial, targetStruct)
    % update the Sturcture with targetStruct field values
    % use targetStruct to update partial
    % partial's fields are always a subset to targetStruct's fields

    % For example, partial is the user defined struct while targetStruct is the default struct

    partialFields=fieldnames(partial);
    for i=1:length(partialFields)
        if isstruct(partial.(partialFields{i}))
            % struct within a struct; we need to recurse
            % Oh I hate recursion
            targetStruct.(partialFields{i}) = updateStruct(partial.(partialFields{i}), targetStruct.(partialFields{i}));

        else
            % only update when the to-be-updated targetStruct field already exists
            if isfield(targetStruct, partialFields{i})
                targetStruct.(partialFields{i}) = partial.(partialFields{i});
            else
                disp(targetStruct);
                error('updateStruct:nonExistentField', 'Trying to update a non-existent field: `%s`! \nYou might have a typo in the field name. See above for a list of valid field names.', partialFields{i});
            end
        end
    end
