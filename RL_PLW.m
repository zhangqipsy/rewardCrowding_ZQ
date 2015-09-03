function [wrkspc] = RL_PLW(conf, mode, Subinfo)





%% exp begins
try




    %save(['data/',Subinfo{1},'/', Subinfo{1}, dataSuffix, date, '.mat'],'Trials','conf', 'Subinfo','flow','mode','data');
    render.matFileName = ['data/',dataPrefix, Subinfo{1} , dataSuffix, date, '.mat'];
    save(render.matFileName,'Trials','conf', 'Subinfo','flow','mode','data');
    wrkspc = load(render.matFileName);
    Display(render.matFileName);
    % Display 'Thanks' Screen
    if mode.imEval_on || mode.octal_on || mode.dotRot_on
        % not end yet
    else
        RL_Regards(w, mode.english_on);
    end

catch
    % save the buggy data for debugging
    save data/buggy.mat;
    Display(char('','','data/buggy.mat saved successfully, use for debugging!',''));
    save(['data/', dataPrefix, Subinfo{1}, dataSuffix, date, 'buggy.mat']);
    wrkspc = load(['data/', dataPrefix, Subinfo{1}, dataSuffix, date, 'buggy.mat']);
    %     disp(['';'';'data/buggy saved successfully, use for debugging!']);
    Screen('CloseAll');
    if mode.audio_on; PsychPortAudio('Close'); end
    Priority(0);
    ShowCursor;
    ListenChar(0);
    psychrethrow(psychlasterror);
    format short;

end

%% exp ends
Screen('CloseAll');
if mode.audio_on; PsychPortAudio('Close'); end
Priority(0);
ShowCursor;
ListenChar(0);

% save data for testing for the last experiment
save data/test.mat
figure;
boxplot(Trials(:,3),Trials(:,2));
title([Subinfo{1} ':' render.task]);
format short;
Display('Experiment was successful!');
