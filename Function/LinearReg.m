function [im_new, R_ad, RMSE] = LinearReg(Sub, Ref, im)
    im_new = zeros(size(im));
    R_ad = zeros(1, size(Sub, 2));  % Preallocate R_ad array
    RMSE = zeros(1, size(Sub, 2));  % Preallocate RMSE array

    for i = 1:size(Sub, 2)
        % Fit linear model
        mdl = fitlm(Sub(:,i), Ref(:,i), 'interactions', 'RobustOpts', 'off');

        % Extract coefficients
        brob = mdl.Coefficients.Estimate;

        % Compute new image using linear regression coefficients
        im_new(:,:,i) = brob(1) + brob(2) .* im(:,:,i);

        % Store adjusted R-squared and RMSE
        R_ad(i) = mdl.Rsquared.Adjusted;
        RMSE(i) = mdl.RMSE;
    end
end
