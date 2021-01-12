function [lines, region] = findScoreBorder(image)
    % �Q�� Canny Edge Detector �h��X����L����t
    edgeImage = edge(image, 'canny', 0.25);
    
    imshow(edgeImage);

    % �Q�� Hough Transform �o��e10�W�� hough peaks�A�C�@�ӳ��N��@���u(�������ƪ��u)
    theta_res = 0.5;
    [H, theta, rho] = hough(edgeImage, 'Theta', -90:theta_res:90-theta_res);
    P = houghpeaks(H, 10, 'threshold', ceil(0.05*max(H(:))));


    % �� 90�ר� ��@�_��A�ù�Ҧ����װ��ƧǳB�z
    angles = theta(P(:,2))-90;
    angles = sort(mod([angles angles+180]+360,360)); 

    % Plot out the lines
    lines = houghlines(image, theta, rho, P);

    values = [10, 15, 2, 17, ...
        3, 19, 7, 16, 8, 11, 14, 9, 12, 5, 20, 1, 18, 4, 13, 6];

    % �N�C�Ӥ��ƤΨ�����������x�s�_��
    region(1:20) = struct('minAngle','%f','maxAngle','%f','value','%d');
    for i = 1:numel(region)
        region(i).minAngle = angles(i);
        region(i).maxAngle = angles(mod(i,numel(angles))+1);
        region(i).value = values(i);
    end
end