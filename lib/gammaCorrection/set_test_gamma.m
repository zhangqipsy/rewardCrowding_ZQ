function set_test_gamma
	% return;
    % load gamma table
    CWD=fileparts(mfilename('fullpath'));
    load([CWD '/' 'test_gamma.mat'],'test_gamma_table');

    Screen('loadnormalizedgammatable',0,test_gamma_table);
end



