function set_left_gamma
	% return;
    % load gamma table
    path=fileparts(mfilename('fullpath'));
    load([path '\' 'test_gamma.mat'],'test_gamma_table');
    
    Screen('loadnormalizedgammatable',0,test_gamma_table);
    
    
    