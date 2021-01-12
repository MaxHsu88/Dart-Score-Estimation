function [score, hitMask] = getScore(x, y, center, region, masks)

    [rows, columns] = size(masks.board);
    x = round(x); y = round(y);

    % �H����L�������I�@����ߡA�ھڭ��𸨪���m�p�⨤��
    hitAngle = atan2(y - center.Centroid(2), (x - center.Centroid(1)));
    hitAngle = mod((hitAngle * 180 / pi) + 360, 360);

    % �d�ݸӨ��׸��b���@�Ӥ��ƪ��϶��̭�
    for i = 1:numel(region)
        if (hitAngle > region(i).minAngle) && (hitAngle <= region(i).maxAngle)
            hitRegion = i;
            break;
        end
    end
    if (hitAngle > region(20).minAngle) || (hitAngle <= region(20).maxAngle)
        hitRegion = 20;
    end    

    % �N���y��(Polar)��ܪk�ഫ�������y��(Cartesian)��ܪk
    [x1, y1] = pol2cart(deg2rad(region(hitRegion).minAngle), max(rows, columns));
    [x2, y2] = pol2cart(deg2rad(region(hitRegion).maxAngle), max(rows, columns));
    % �q����L���ߪu�ۨⰼ�����i�X������
    hitMask = poly2mask([0 x1 x2] + center.Centroid(1), ...
                        [0 y1 y2] + center.Centroid(2), ...
                        rows, columns);

    % �d�ݭ��𸨦b���ӱo���ϰ�(ex:�歿�B�����B�T���B�S�o��)
    score = region(hitRegion).value;
    if masks.single(y, x)
        hitMask = masks.single .* hitMask;
    elseif masks.double(y, x)
        score = score * 2;
        hitMask = masks.double .* hitMask;
    elseif masks.triple(y, x)
        score = score * 3;
        hitMask = masks.triple .* hitMask;
    elseif masks.miss(y, x)
        score = score * 0;
        hitMask = masks.miss;
    elseif masks.innerBull(y, x)
        score = 50;
        hitMask = masks.innerBull;
    elseif masks.outerBull(y, x)
        score = 25;
        hitMask = masks.outerBull;
    end

    hitMask = hitMask > 0.5;
end

