function [NormImg, RMSE, R_ad] = LIRRN(P_N, SubImg, RefImg)
    ID = randi([1, P_N], round(0.1 * P_N), 1);
    NormImg = zeros(size(SubImg));
    RMSE = zeros(1, size(SubImg, 3));
    R_ad = zeros(1, size(SubImg, 3));

    % Preallocate label matrices
    SubLabel = zeros(size(SubImg));
    RefLabel = zeros(size(RefImg));

    for jj = 1:size(SubImg, 3)
        thresh = multithresh(nonzeros(SubImg(:,:,jj)), 2);
        SubLabel(:,:,jj) = imquantize(SubImg(:,:,jj), thresh);
        thresh = multithresh(nonzeros(RefImg(:,:,jj)), 2);
        RefLabel(:,:,jj) = imquantize(RefImg(:,:,jj), thresh);
    end

    for j = 1:size(SubImg, 3)
        Sub1 = cell(3, 1);
        Ref1 = cell(3, 1);

        for i = 1:3
            A = (RefLabel(:,:,j) == i) .* RefImg(:,:,j);
            B = (SubLabel(:,:,j) == i) .* SubImg(:,:,j);

            % Sample selection
            [Sub, Ref] = SampleSelection(P_N, A, B, ID);

            Sub1{i} = Sub;
            Ref1{i} = Ref;
        end

        a = cell2mat(Sub1);
        b = cell2mat(Ref1);
        [NormImg(:,:,j), R_ad(j), RMSE(j)] = LinearReg(a, b, SubImg(:,:,j));
    end
end

function [Sub, Ref] = SampleSelection(P_N, A, B, ID)
    % Compute distances between reference and subject points
    A1 = nonzeros(A);
    B1 = nonzeros(B);

    % Sample selection
    [Sub_1, Ref_1] = ComputeSample(P_N, A1, B1, ID);
    
    Sub = [Sub_1(Sub_1 ~= 0); Sub_1(Sub_1 == 0)]; % Append zeros at the end
    Ref = [Ref_1(Ref_1 ~= 0); Ref_1(Ref_1 == 0)]; % Append zeros at the end
end

function [Sub_1, Ref_1] = ComputeSample(P_N, A1, B1, ID)
    % Compute distances between the maximum-based reference and subject points
    [Sub_1, Ref_1] = ComputeDistances(P_N, A1, B1, ID);

    % Compute distances between the minimum-based reference and subject points
    [Sub_2, Ref_2] = ComputeDistances(P_N, A1, B1, ID);

    % Compute distances between the mean-based reference and subject points
    [Sub_3, Ref_3] = ComputeDistances(P_N, A1, B1, ID);

    % Collect the reference and subject points
    Sub_1 = [Sub_1(Sub_1 ~= 0); Sub_2(Sub_2 ~= 0); Sub_3(Sub_3 ~= 0)];
    Ref_1 = [Ref_1(Ref_1 ~= 0); Ref_2(Ref_2 ~= 0); Ref_3(Ref_3 ~= 0)];
end

function [Sub, Ref] = ComputeDistances(P_N, A1, B1, ID)
    % Compute distances between the maximum-based reference and subject points
    MaX = max(A1);
    AS = abs(A1 - MaX);
    [~, idx_refmax] = sort(AS);
    Ref_max_nO = (A1(idx_refmax(1:P_N)));

    % Compute distances between the maximum-based subject points
    MaX = max(B1);
    AS = abs(B1 - MaX);
    [~, idx_submax] = sort(AS);
    Sub_max_nO = (B1(idx_submax(1:P_N)));

    % Sample selection based on ID
    Sub = Sub_max_nO(ID);
    Ref = Ref_max_nO(ID);
end
