function [masks] = findRegionMasks(image)

    grayImage = rgb2gray(image);

    redRegions = image(:,:,1) - grayImage;
    masks.red = redRegions > graythresh(redRegions);

    greenRegions = image(:,:,2) - grayImage;
    masks.green = greenRegions > graythresh(greenRegions);

    % ���ƥ[���������Ϭ�����۶��A�G�N��Ӱ��ۥ[�o��[����
    masks.multipliers = masks.red + masks.green;

    % �Q�� disk structural element �h�� dilation�A����񤧶����_�ظɻ�
    se = strel('disk', round(numel(image(:,1,1))/100));
    masks.multRings = imclose(masks.multipliers, se);
    
    % ��[���ϥH���������񺡧Y����Ӷ�L�����ıo���ϰ�
    masks.board = imfill(masks.multRings, 'holes');
    % �H�~�h���L�ıo���ϰ�
    masks.miss = ~masks.board;

    % �[���ϥH�~���a�謰single area
    masks.single = masks.board - masks.multRings;
    % �йv���̥~��double area
    masks.double = masks.board - imfill(masks.single, 'holes');

    innerRing = imfill((masks.board - masks.double - masks.single), 'holes') - ...
        (masks.board - masks.double - masks.single);

    % ��L����������triple area
    masks.triple = masks.board - masks.double - masks.single - imfill(innerRing, 'holes');
    masks.triple(masks.triple < 0) = 0;

    % ��L���߬�bulleye
    masks.outerBull = (masks.multRings - masks.double - masks.triple) .* masks.green;
    masks.innerBull = (masks.multRings - masks.double - masks.triple) .* masks.red;
    
    % ��Ӷ�L(�]�t�L�o�����ϰ�)
    edgeImage = edge(grayImage, 'canny', 0.25);
    im_dilate = imfill(imdilate(edgeImage, ...
                    strel('disk', round(size(edgeImage, 1)/150))), 'holes');
    % Erode�{�פ�Dilate�j�H�קK��L��ɻ~�t�Q�Ҽ{�i�h
    whole_board = imerode(im_dilate, ...
                    strel('disk', round(size(edgeImage, 1)/80)));
    masks.whole_board = whole_board;
end

