function outVol = isolateRegion3D(vol, pt, conn)
    % vol: 3D binary volume (0/1)
    % pt: 1x3 subvoxel point [x y z]
    % conn: 6, 18, or 26 connectivity

    if nargin < 3
        conn = 6;  % conservative default
    end

    % Round point to nearest voxel index
    voxelIdx = round(pt);
    sz = size(vol);
    if any(voxelIdx < 1) || any(voxelIdx > sz)
        error('Point is out of volume bounds.');
    end

    % Determine the value (0 or 1) at the point
    voxelVal = vol(voxelIdx(2), voxelIdx(1), voxelIdx(3));  % (Y, X, Z)

    % Perform connected component labeling on matching value
%     conn = 6;
    CC{1} = bwconncomp(vol, conn);
    CC{2} = bwconncomp(~vol, conn);

    
    
    if CC{1}.NumObjects ==2 && CC{2}.NumObjects~=2
        if length(CC{1}.PixelIdxList{1})>=length(CC{1}.PixelIdxList{2})
            vol(CC{1}.PixelIdxList{2}) = 0;
        else
            vol(CC{1}.PixelIdxList{1}) = 0;
        end
        
    end
    
    if CC{2}.NumObjects ==2 && CC{1}.NumObjects~=2
        if length(CC{2}.PixelIdxList{1})>=length(CC{2}.PixelIdxList{2})
            vol(CC{2}.PixelIdxList{2}) = 1;
        else
            vol(CC{1}.PixelIdxList{1}) = 1;
        end
        
    end
    
    
    if CC{2}.NumObjects ==2 && CC{1}.NumObjects==2
        
        num_all = zeros(1,2);
        for i = 1:2
             for j = 1:length(CC{i}.PixelIdxList)
                 num_all(i) = num_all(i)+length(CC{i}.PixelIdxList{j});
             end
        end
        [~,indx] = sort(num_all);
        
        k = vol(CC{indx(2)}.PixelIdxList{1}(1));
        for i = 1:length(CC{indx(2)}.PixelIdxList)
            num_new(i) = length(CC{indx(2)}.PixelIdxList{i});
        end
        [~,indx_new] = sort(num_new);
        vol(CC{indx(2)}.PixelIdxList{indx_new(1)}) = 1-k;  
    end
    
    
    outVol = vol;
    
%     if CC{2}.NumObjects ==2 && CC{1}.NumObjects~=2
%     end
        
    
    
%     if voxelVal == 1
%         CC = bwconncomp(vol == 1, conn);
%     else
%         CC = bwconncomp(vol == 0, conn);
%     end

    % Convert to linear index
%     linIdx = sub2ind(sz, voxelIdx(2), voxelIdx(1), voxelIdx(3));
% 
%     % Find the connected component containing the point
%     regionToKeep = 0;
%     for i = 1:CC.NumObjects
%         if ismember(linIdx, CC.PixelIdxList{i})
%             regionToKeep = i;
%             break;
%         end
%     end
% 
%     % Construct output volume
%     outVol = zeros(sz);
%     if regionToKeep > 0
%         outVol(CC.PixelIdxList{regionToKeep}) = voxelVal;
%     else
%         warning('Point is not inside any region.');
%     end
end


