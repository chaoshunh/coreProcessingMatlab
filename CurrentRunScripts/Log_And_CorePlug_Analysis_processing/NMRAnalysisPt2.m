%%NMRAnalysis Pt2
clear all;
data = open('NMRResultsArrays.mat');
faciesPropResults = data.faciesPropResults;
resultsArray = data.resultsArray;
clear data;
width = size(faciesPropResults,2);
for x = 1:length(faciesPropResults)
    for y = 1:length(resultsArray)
        if resultsArray(y,1) == faciesPropResults(x,1)
            
                for z = 3:size(resultsArray,2)
                    faciesPropResults(x,width + (z - 2)) = resultsArray(y,z);
                end
            
        end
    end
end

for x = 3:width
    frameCount = 0;
    for y = width+1:size(faciesPropResults,2)
        aString = strcat('% Resistivity Above: ', mat2str((((y - width)+1) * 10) -10), 'ohms');
        faciesString = strcat('% of Facies Code: ', mat2str(x));
        cutoffString = strcat('Resistivity Cutoff = ', mat2str((((y - width)+1) * 10) -10),'ohms');
        % Create figure
        figure1 = figure;
        
        % Create axes
        axes1 = axes('Parent',figure1);
        %% Uncomment the following line to preserve the X-limits of the axes
         xlim(axes1,[0 0.15]);
        %% Uncomment the following line to preserve the Y-limits of the axes
         ylim(axes1,[0 1]);
        %% Uncomment the following line to preserve the Z-limits of the axes
         zlim(axes1,[0 1]);
        view(axes1,[-37.5 30]);
        box(axes1,'on');
        grid(axes1,'on');
        hold(axes1,'on');
        
        % Create zlabel
        zlabel({aString},'FontSize',20);
        
        % Create ylabel
        ylabel({faciesString},'FontSize',20);
        
        % Create xlabel
        xlabel({'NMR Free Fluid Volume'},'FontSize',20);
        
        % Create title
        title({'NMR FFV vs Facies % vs Resistivity Above Cutoff'},'FontSize',24);
        
        % Create scatter3
        scatter3(faciesPropResults(:,2), faciesPropResults(:,x), faciesPropResults(:,y), [], faciesPropResults(:,x));
        
        % Create colorbar
        colorbar('peer',axes1,'Position',...
            [0.944005412719893 0.0899713876967096 0.013531799729364 0.815]);
        
        % Create textbox
        annotation(figure1,'textbox',...
            [0.130228687415426 0.829756795422032 0.404683355886333 0.0701001430615165],...
            'String',cutoffString,...
            'LineStyle','none',...
            'FontSize',20,...
            'FitBoxToText','off');
        
        %h = scatter3(faciesPropResults(:,2), faciesPropResults(:,x), faciesPropResults(:,y), [], faciesPropResults(:,x));
        
        %annotation('textbox',[0.4,0.8,0.4,0.2],'String', aString, 'FontSize', 20);
        filename = strcat('FaciesCode_', mat2str(x), '_ResistivityCutoff_', mat2str((((y - width)+1) * 10) -10),'.fig');
        saveas(gcf, filename);
        frameCount = frameCount + 1;
        movieFrames(frameCount,1) = getframe(gcf);
        close(gcf);
    end
    movie(movieFrames);
    movieName = strcat('FaciesCode_', mat2str(x),'_AnimatedPlot','.avi');
    writerObj = VideoWriter(movieName);
    writerObj.FrameRate = 2; %%FPS
    open(writerObj);
    writeVideo(writerObj,movieFrames);
    close(writerObj);
    clear movieFrames;
end


