%% Setup
clear all;
% Set up vlfeat Toolbox
run('vlfeat-0.9.21/toolbox/vl_setup.m'); % path to vlfeat
warning off;

%% Games Settings
fprintf('Setting up games......\n');
init_points = 301;
num_players = 2;

playerPoints = zeros(num_players, 1);
for i = 1:num_players
   playerPoints(i) = init_points; 
end

img_scale = 1;
final_winner = 0;
endgame = 0;

%% Camera Settings
fprintf('Setting Cameras......\n');
m = mobiledev;
cam = camera(m, 'back');
cam.Resolution = '1280x720';

%% Load Background Image
fprintf('Capturing Background Image.....\n');
backgroundImage = snapshot(cam, 'manual');

%% Calculate Points
fprintf('Starting Dart Game.....\n');

while final_winner == 0 && endgame == 0
    for i = 1:num_players
       while 1
           showText = sprintf('Player %d throwing...(Press "1" to start, "0" to leave the game)   \n', i);
           response = input(showText);
           if response == 1
               fprintf('Opening Webcam...\n');
               break;
           elseif response == 0
               endgame = 1;
               break;
           else
               fprintf('Invalid input!!!\n');
           end
       end
       if(endgame)
            break;
       end
       % ��J�g�����𪺹Ϥ�
       dartImage = snapshot(cam, 'manual');
       % �p��o��
       points = estimateDartScore(backgroundImage, dartImage, img_scale);
       % �������a�o��
       prev_points = playerPoints(i);
       cur_points = playerPoints(i) - points;
       
       if (cur_points < 0)
           playerPoints(i) = prev_points;
       else
           playerPoints(i) = cur_points;
       end
       fprintf('\n\nPlayer %d: %d\n\n', i, playerPoints(i));
    end
    % �p�G�����Y�����C��
    iszero = find(playerPoints(i) == 0);
    if(isempty(iszero))
        final_winner = 0;  
    else
        frpintf('Player %d wins\n', iszeros(1));  % which one wins?
        final_winner = 1;
    end
end

%% Print Results
