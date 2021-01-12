function [xhit, yhit, num_dart] = findDartLocation(dart, masks)
    
    rows = size(dart, 1);
    % ���� dart map �� disk dilation�A��ϰ�ɰ_��
    dart_mask = (imdilate(dart.^2 > 0.2 * graythresh(dart.^2), ...
        strel('disk', round(rows/100))));
    % ��X�Ӱϰ쪺 orientation
    sDart = regionprops(dart_mask, 'Orientation', 'Area');
    [~, dartIndex] = max([sDart(:).Area]);
    
    % �ھګe���� orientation ���G�A�u�۸Ӥ�V�h�� dart map �� line dilation
    dart_mask = (imclose(dart.^2 > 0.2*graythresh(dart.^2), ...
        strel('line', 50, sDart(dartIndex).Orientation)));
    sDart = regionprops(dart_mask, 'Orientation', 'Area', 'Extrema', 'PixelList', 'BoundingBox');
    
    figure;
    imshow(dart_mask);
    % ��X��ӭ���L���e��
    sBoard = regionprops(masks.whole_board, 'Area', 'BoundingBox');
    [~, boardIndex] = max([sBoard(:).Area]);
    board_width = sBoard(boardIndex).BoundingBox(3);
    
    % ��X�Ҧ��ϰ쪺Bounding Box���e��
    dart_bbox = vertcat(sDart(:).BoundingBox);
    dart_width = dart_bbox(:, 3);
    
    % �Y�Ӱϰ�e�שM����L�e�פ�Ҥj��0.1�A�h��i�ର������
    isDart_thresh = 0.1;
    ratio = dart_width / board_width
    dartIndex = find(ratio > isDart_thresh);

    num_dart = length(dartIndex);
    if num_dart > 3
        num_dart = 0;
    end
    
    % ��췥�Ȫ��y�з�@���𸨦b����L�W����m
    xhit = zeros(num_dart, 1);
    yhit = zeros(num_dart, 1);
    for i = 1:num_dart
        if (sDart(dartIndex(i)).Orientation < 0)
            xhit(i) = sDart(dartIndex(i)).Extrema(7,1);
            yhit(i) = sDart(dartIndex(i)).Extrema(7,2);
        else
            xhit(i) = sDart(dartIndex(i)).Extrema(8,1);
            yhit(i) = sDart(dartIndex(i)).Extrema(8,2);
        end
    end
end