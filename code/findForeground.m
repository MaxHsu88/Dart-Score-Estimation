function dart_heatmap = findForeground(dartImage, backgroundImage, masks, type)
    % ��Ϥ��� Gaussian Blur ���ϰ�S�x����@�I
    if type == 0   % HQ
        sigma = 5;
        h = fspecial('gaussian', 5*sigma + 1, 5);
    elseif type == 1  % LQ
        sigma = round(size(dartImage, 2)/200);
        h = fspecial('gaussian', 5*sigma + 1, sigma);
    end
    
    dartImageBlur = imfilter(dartImage, h, 'replicate');
    backgroundImageBlur = imfilter(backgroundImage, h, 'replicate');
    dartImageBlur(isnan(dartImage)) = backgroundImageBlur(isnan(dartImage));
    
    % ��ӹϤ��b����L�W���t��
    blueDiff = mat2gray(rgb2gray(dartImageBlur - backgroundImageBlur));
    grayDiff = mat2gray(rgb2gray(backgroundImageBlur - dartImageBlur));
    
    dart_heatmap = mat2gray(blueDiff + grayDiff) .* masks.whole_board;
end