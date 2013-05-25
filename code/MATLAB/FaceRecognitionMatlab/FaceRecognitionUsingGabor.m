function FaceRecognitionUsingGabor(inputFile)


    disp('Displaying input image.')
    figure(1)
    imshow(inputFile);
    disp('Press any key to continue ...')
    pause();


trainIndex = 40;

%% Load image database

% construct Gabor filter bank 
filter_bank = construct_Gabor_filters_PhD(8, 5, [128 128]);

%filter image
proceed = 1;
train_data = [];
ids_train = [];

try
    % construct image string, load image and extract features
    for i=1:trainIndex
        for j=1:10
            s = sprintf('database/s%i/%i.pgm',i,j);
            X = double(imread(s));
            X = imresize(X,[128 128],'bilinear');
            feature_vector = filter_image_with_Gabor_bank_PhD(X,filter_bank,64);
            train_data = [train_data,feature_vector];
            ids_train = [ids_train;i];    
        end
         disp(sprintf('Finished with feature extraction from database store index %i', i));
    end
    [size_y,size_x] = size(X);    
catch
   proceed = 0;
   disp('Could not load images from the ORL database.');
end



if(proceed)
    disp('Finished with Step 1 (database loading).')
 
    %% Partitioning of the data
        test_data = [];
        X = double(imread(inputFile));        
        X = imresize(X,[128 128],'bilinear');
        feature_vector = filter_image_with_Gabor_bank_PhD(X,filter_bank,64);
        test_data = [test_data,feature_vector];           
    disp('Finished with Step 2 (input image loading and feature extraction).')
   
	%% Construct KFA subspace
    model = perform_kfa_PhD(train_data, ids_train, 'fpp', [0 0.7],length(unique(ids_train))-1);
       
    disp('Finished KFA subspace construction. Starting evaluation and test image projection.')
    test_features = nonlinear_subspace_projection_PhD(test_data, model);   
    %% Compute similarity matrix
   results1 = nn_classification_PhD(model.train, ids_train, test_features, 1, size(test_features,1), 'euc','all');
   [match_score, match_ix] = min(results1.match_dist);
   disp('Found matching Images')
   display(match_ix);
   display(match_score);
   
   disp('Loading similar Images of input image')
     i= ceil(match_ix / 10);
        for j=1:10
            s = sprintf('database/s%i/%i.pgm',i,j);
            figure(j + 1)
            imshow(s);                     
        end
    
end
disp('Finished demo.')




















