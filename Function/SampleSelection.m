function [Sub_1, Ref_1] = SampleSelection(Sub, Ref)
    dist = pdist2(Sub, Ref);
    [numSub, numRef] = size(dist);
    Sub_1 = zeros(numSub, 1);
    Ref_1 = zeros(numSub, 1);
    S = 0;

    while S < numSub
        [minDist, idx] = min(dist(:));
        [x, y] = ind2sub([numSub, numRef], idx);
        Sub_1(S + 1, 1) = Sub(x);
        Ref_1(S + 1, 1) = Ref(y);
        S = S + 1;
        
        % Remove selected row and column from distance matrix
        dist(x, :) = Inf;
        dist(:, y) = Inf;
    end
end
