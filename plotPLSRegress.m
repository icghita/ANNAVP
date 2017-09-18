function plotPLSRegress(inputs, outputs)
    if(iscell(inputs))
        colors = colormap(jet);
        colorSpacing = floor(length(colors)/length(inputs));
        for i=1:length(inputs)
            try
                [~,~,~,~,betaPLS,PCTVAR,PLSmsep] = plsregress(inputs{i}', outputs', 10, 'CV', 10);
            catch
                [~,~,~,~,betaPLS,PCTVAR,PLSmsep] = plsregress(inputs{i}', outputs');
            end
            subplot(2,2,1);
            plot(1:length(cumsum(100*PCTVAR(2,:))), cumsum(100*PCTVAR(2,:)), '-o', 'Color', colors(i*colorSpacing,:)), hold on;
            xlabel('Number of PLS components');
            ylabel('Percent Variance Explained in Neutralization Data');

            yfitPLS = [ones(size(inputs{i}', 1), 1) inputs{i}']*betaPLS;   
            subplot(2,2,2);
            plot(outputs' ,yfitPLS, '-o', 'Color', colors(i*colorSpacing,:)), hold on;
            xlabel('Observed Response');
            ylabel('Fitted Response');
            legend('R = 0.9995');

            subplot(2,2,3);
            plot(0:length(PLSmsep(2,:))-1, PLSmsep(2,:), '-o', 'Color', colors(i*colorSpacing,:)), hold on;
            xlabel('Number of components');
            ylabel('Estimated Mean Squared Prediction Error');
            legend('Partial Least Squares Regression');
        end
    else
        try
            [~,~,~,~,betaPLS,PCTVAR,PLSmsep] = plsregress(inputs', outputs', 10, 'CV', 10);
        catch
            [~,~,~,~,betaPLS,PCTVAR,PLSmsep] = plsregress(inputs', outputs');
        end
        subplot(2,2,1);
        plot(1:length(cumsum(100*PCTVAR(2,:))), cumsum(100*PCTVAR(2,:)), '-bo');
        xlabel('Number of PLS components');
        ylabel('Percent Variance Explained in Neutralization Data');

        yfitPLS = [ones(size(inputs', 1), 1) inputs']*betaPLS;   
        subplot(2,2,2);
        plot(outputs' ,yfitPLS, 'bo');
        xlabel('Observed Response');
        ylabel('Fitted Response');
        legend('R = 0.9995');

        subplot(2,2,3);
        plot(0:length(PLSmsep(2,:))-1, PLSmsep(2,:), 'b-o');
        xlabel('Number of components');
        ylabel('Estimated Mean Squared Prediction Error');
        legend('Partial Least Squares Regression');
    end
end

