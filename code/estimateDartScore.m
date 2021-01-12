function [total_points]  = estimateDartScore(backgroundImage, dartImage, scale)

    % Set up vlfeat Toolbox
    % run('vlfeat-0.9.21/toolbox/vl_setup.m'); % path to vlfeat
    % warning off;

    %% �M�w�B�z�Ϥ����Ѽ�
    % scale = 0.5;      % �Ϥ��Y��j�p

    %% �ϥΪ̿�J�Ϥ�
%     fprintf('Select Background Image.\n');
    backgroundImage = imresize(im2double(backgroundImage), scale);

%     fprintf('Select Dart Image..\n');
    dartImage = imresize(im2double(dartImage), scale);

    %% ��������L�i�઺�ϰ�è̦����Ϥ�����
%     fprintf('Cropping DartBoard....\n');
    [backgroundImage, grayBackgroundImage, dartImage, grayDartImage] = cropDartBoard(backgroundImage, dartImage);
    [rows, columns, channels] = size(backgroundImage);

    %% �s�@�o���ϰ��
%     fprintf('Creating Pointmap.....\n');

    % ���C�@�ӱo���ϰ쪺mask
    masks = findRegionMasks(backgroundImage);

    % ��줤���I����߮y��
    center = regionprops(masks.innerBull, 'Centroid');

    % ��X�C�Ӥ��ư϶����������j�u
    [lines, region] = findScoreBorder(grayBackgroundImage .* masks.board);

    %% ����Ϥ��A����ӹϤ�����۪�
%     fprintf('Aligning Images.....\n');
    [dartImage, grayDartImage] = alignImage(grayBackgroundImage, grayDartImage, backgroundImage, dartImage);

    %% �z�L��ӹϤ����t����X�e������ Heatmap
%     fprintf('Detecting Foreground.....\n');
    dart = findForeground(dartImage, backgroundImage, masks);

    %% �z�L�� Heatmap ���B�z�o�쭸��y�Y���b�L�W����m
%     fprintf('Finding Dart Location.......\n');
    [xhit, yhit, num_dart] = findDartLocation_v2(dart, masks);

    %% �p���`�o��
%     fprintf('Calculating Final Score.......\n');
    total_points = 0;
    total_mask = false(rows, columns);
    for i = 1:num_dart
        [points, hit_mask] = getScore(xhit(i), yhit(i), center, region, masks);
        total_mask = total_mask | hit_mask;
        total_points = total_points + points;
    end

       %% Display on Images
%     fprintf('Displaying Results........\n');
    gcf = figure(1);
    imshow(dartImage);
    hold on;

    boundary = bwboundaries(total_mask);
    for numRegion = 1:numel(boundary)
        plot(boundary{numRegion,1}(:,2), boundary{numRegion,1}(:,1), 'y', 'LineWidth', 2)
    end

    text(columns/2,rows,sprintf('Total Points: %d', total_points), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 28, ...
        'FontWeight', 'bold', ...
        'Color', 'b', ...
        'BackgroundColor', 'w');
    pause(2);
    hold off; 

    warning on;
    
%     fprintf('Program Complete!\n');
    
    % frame = getframe(gcf);
    % [displayImage, ~] = frame2im(frame);
    
end