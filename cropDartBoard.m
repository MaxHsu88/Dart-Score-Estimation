function [backgroundImage, grayBackgroundImage, dartImage, grayDartImage] = cropDartBoard(backgroundImage, dartImage)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Note: �I��������¥B���L��   %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % ���N�Ϥ��� Gray Level Thresholding
    grayBackgroundImage = rgb2gray(backgroundImage);
    BWBackgroundImage = grayBackgroundImage > graythresh(grayBackgroundImage);
    % �Q�� FloodFill �覡�N�լ}�ɤW
    background = imfill(~BWBackgroundImage,'holes');
    
    % ��X�̤j�� Connected Components ��@ DartBoard ���d��
    s = regionprops(background,'BoundingBox','Area');
    [~, idx] = max([s(:).Area]);

    % �̷� Proposed DartBoard Region �h��Ϥ�������
    backgroundImage = backgroundImage(ceil(s(idx).BoundingBox(2)):floor(s(idx).BoundingBox(2)+s(idx).BoundingBox(4)),...
           ceil(s(idx).BoundingBox(1)):floor(s(idx).BoundingBox(1)+s(idx).BoundingBox(3)),:);
    grayBackgroundImage = rgb2gray(backgroundImage);

    dartImage = dartImage(ceil(s(idx).BoundingBox(2)):floor(s(idx).BoundingBox(2)+s(idx).BoundingBox(4)),...
           ceil(s(idx).BoundingBox(1)):floor(s(idx).BoundingBox(1)+s(idx).BoundingBox(3)),:);
    grayDartImage = rgb2gray(dartImage);
end