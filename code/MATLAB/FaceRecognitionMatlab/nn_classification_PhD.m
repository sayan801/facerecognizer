
function results = nn_classification_PhD(train, train_ids, test, test_ids, n, dist, match_kind);


%% Init 
results = [];


%% Check inputs

%check number of inputs
if nargin <4
    disp('Wrong number of input parameters! The function requires at least four input arguments.')
    return;
elseif nargin >7
    disp('Wrong number of input parameters! The function takes no more than seven input arguments.')
    return;
elseif nargin==4
    n = size(train,1);
    dist = 'cos';
    match_kind = 'all'
elseif nargin ==5
    dist = 'cos';
    match_kind = 'all';
elseif nargin ==6
    match_kind = 'all';    
end

%check distance
if ischar(dist)~=1
    disp('The parameter "dist" needs to be a string - a valid one!')
    return;
end

%check if test and train features are of same size
[a,b]=size(train);
[c,d]=size(test);
if a~=c
    disp('The number of features in the training and test vectors needs to be identical.')
    return;
end

%check the matching type 
if ischar(match_kind)~=1
    disp('The parameter "match_kind" has to be a string - a valid one!')
    return;
end

%check if match_kind is a valid string
if strcmp(match_kind,'all')==1 || strcmp(match_kind,'sep')==1 || strcmp(match_kind,'allID')==1
    %ok
else
    disp('The input string "match_kind" is not a valid identifier: all|sep.')
    return;
end

%check if n is not to big
if n>a
    disp('The parameter "n" cannot be larger than the dimensionality of your feature vectors. Decreasing "n" to maximal allowed size.')
    n=a;
end

%check if the distance is valid
if strcmp(dist,'cos')==1 || strcmp(dist,'euc')==1 || strcmp(dist,'ctb')==1 || strcmp(dist,'mahcos')==1
    %ok
else
    disp('The parameter "dist" need to be a valid string identifier: cos, euc, ctb, or mah. Switching to deafults (cos).')
    dist = 'cos';
end

%check if ids (class labels) are vectors
if isvector(train_ids)==0 
    disp('The second parameter "train_ids" needs to be a vector of numeric values.')
    return;
end

if isvector(test_ids)==0
    disp('The second parameter "train_ids" needs to be a vector of numeric values.')
    return;
end

%check that each feature vector has a label
[a,b]=size(train);
if b~=length(train_ids)
    disp('The label vector "train_ids" needs to be the same size as the number of samples in "train".')
    return;
end

[c,d]=size(test);
if d~=length(test_ids)
    disp('The label vector "test_ids" needs to be the same size as the number of samples in "test".')
    return;
end

%% Prepare data and do the matching - main part

%get sample sizes
[a,b]=size(train);
[c,d]=size(test);

%precompute the inverse of the covariance if needed
covar = inv(cov(train(1:n,:)'));

%select type of matching
if strcmp(match_kind,'sep')==1
    %the "sep" option separates the test data into two groups - clients and 
    %impostors (needed by some protocols) - this is useful for verification
    %with an unseen impostor set (e.g., XM2VTS), the identification score
    %can still be computed from the client similarity matrix
    
    %write matching mode to result structure
    results.mode = 'sep';
    
    %find impostor labels
    impostor_ids = setdiff(test_ids,train_ids);
    if size(impostor_ids,1)==0 || size(impostor_ids,2)==0
        disp('In separation mode, the query data matrix has to feature at least some subjects that are not in the target set.')
        return;
    end
    
    %find client labels
    client_ids = intersect(test_ids,train_ids);
    if size(client_ids,1)==0 || size(client_ids,2)==0
        disp('In separation mode, the query data matrix has to feature at least some subjects that are also in the target set.')
        return;
    end
    
    
    %some reporting
    disp('Entering separation mode!')
    
    
    %seperate and compute the distances 
    
    %clients - extract client data
    num_of_experiments = 0;
    for i=1:length(client_ids)
        [incr,dummy] = find(client_ids(i)==test_ids); 
        num_of_experiments = num_of_experiments + sum(incr);
    end
    
    %we rather add another for loop now that we know the size - this is
    %faster than realocating space in each iteration - štrikam
    test_cli = zeros(n,num_of_experiments);
    test_cli_ids = zeros(1,num_of_experiments);
    cont=1;
    for i=1:length(client_ids)
        [incr,dummy] = find(client_ids(i)==test_ids); 
        test_cli(:,cont:cont+length(incr)-1) = test(1:n,dummy);
        test_cli_ids(1,cont:cont+length(incr)-1) = client_ids(i);
        cont = cont+length(incr);
    end
    
    
    %some reporting
    disp('Computing client similarity matrix ...')
    
    
    %compute distances
    results.client_dist = zeros(num_of_experiments,b);
    results.same_cli_id = zeros(num_of_experiments,b);
    for i=1:num_of_experiments
        for j=1:b
            results.client_dist(i,j) = return_PhD_distance(train(1:n,j),test_cli(1:n,i),dist,covar);
            if train_ids(j)==test_cli_ids(i)
                results.same_cli_id(i,j)=1;
            else
                results.same_cli_id(i,j)=0;
            end
        end
    end
    results.client_horizontal_ids = train_ids;
    results.client_vertical_ids = test_cli_ids;
    
    disp('Done.')
    
    
    disp('Computing impostor scores ...')
    %impostors - extract impostor data
    num_of_experiments = 0;
    for i=1:length(impostor_ids)
        [incr,dummy] = find(impostor_ids(i)==test_ids); 
        num_of_experiments = num_of_experiments + sum(incr);
    end
    
    
    %we rather add another for loop now that we know the size - this is
    %faster than realocating space in each iteration - štrikam
    test_imp = zeros(n,num_of_experiments);
    test_imp_ids = zeros(1,num_of_experiments);
    cont=1;
    for i=1:length(impostor_ids)
        [incr,dummy] = find(impostor_ids(i)==test_ids); 
        test_imp(:,cont:cont+length(incr)-1) = test(1:n,dummy);
        test_imp_ids(1,cont:cont+length(incr)-1) = impostor_ids(i);
        cont = cont+length(incr);
    end
    
    %compute distances
    results.imp_dist = zeros(num_of_experiments,b);
    results.same_imp_id = zeros(num_of_experiments,b);
    for i=1:num_of_experiments
        for j=1:b
            results.imp_dist(i,j) = return_PhD_distance(train(1:n,j),test_imp(1:n,i),dist,covar);
            if train_ids(j)==test_imp_ids(i)
                results.same_imp_id(i,j)=1;
            else
                results.same_imp_id(i,j)=0;
            end
        end
    end
    results.imp_horizontal_ids = train_ids;
    results.imp_vertical_ids = test_imp_ids;
    results.dist = dist;
    results.dim = n; 
    disp('Done.')
elseif strcmp(match_kind,'all')==1
    %the "all" option matches each samples from the test matrix against all
    %samples form the train matrix
    
    %write matching mode to result structure
    results.mode = 'all';
    
    %find client labels
    client_ids = intersect(test_ids,train_ids);
    if size(client_ids,1)==0 || size(client_ids,2)==0
        disp('In all mode, the query data matrix has to feature at least some subjects that are also in the target set.')
        return;
    end
    
    
    %some reporting
    disp('Entering all mode!')
    disp('Computing similarity matrix ...')
    
    %compute distances
    results.match_dist = zeros(d,b);
    %results.same_id = zeros(d,b);
    for i=1:d
        for j=1:b
            results.match_dist(i,j) = return_PhD_distance(train(1:n,j),test(1:n,i),dist,covar);
            if train_ids(j)==test_ids(i)
                results.same_cli_id(i,j)=1;
            else
                results.same_cli_id(i,j)=0;
            end
        end
    end
    results.horizontal_ids = train_ids;
    results.vertical_ids = test_ids;
    results.dist = dist;
    results.dim = n; 
    disp('Done.')
elseif strcmp(match_kind,'allID')==1
    %the "allID" option matches each samples from the test matrix against all
    %IDs form the train matrix - each ID here is represented with the mean
    %feature vector of that ID - this is just for me and I will not
    %document it
    
    %write matching mode to result structure
    results.mode = 'all';
    
    %find client labels
    client_ids = intersect(test_ids,train_ids);
    if size(client_ids,1)==0 || size(client_ids,2)==0
        disp('In all mode, the query data matrix has to feature at least some subjects that are also in the target set.')
        return;
    end
    
    
    
    
%     [incr,dummy] = find(impostor_ids(i)==test_ids); 
%         test_imp(:,cont:cont+length(incr)-1) = test(1:n,dummy);
%         test_imp_ids(1,cont:cont+length(incr)-1) = impostor_ids(i);
%         cont = cont+length(incr);
        
        
        
        
    %some reporting
    disp('Entering allID mode!')
    
    disp('Computing client prototypes ...')
%     prototypes = zeros(size(train_ids,1),length(client_ids));
    cont=1;
    for i=1:length(client_ids);
       [incr,dummy] = find(client_ids(i) == train_ids);
       train(1:n,cont:cont+length(incr)-1) = repmat(mean(train(1:n,dummy),2),1,length(incr));        
    end
    
    
    disp('Computing similarity matrix ...')
    
    %compute distances
    results.match_dist = zeros(d,b);
    results.same_id = zeros(d,b);
    for i=1:d
        for j=1:b
            results.match_dist(i,j) = return_PhD_distance(train(1:n,j),test(1:n,i),dist,covar);
            if train_ids(j)==test_ids(i)
                results.same_cli_id(i,j)=1;
            else
                results.same_cli_id(i,j)=0;
            end
        end
    end
    results.horizontal_ids = train_ids;
    results.vertical_ids = test_ids;
    results.dist = dist;
    results.dim = n; 
    disp('Done.')  
end



















%% This is an auxilary function that returns the specified distance
% 
% Protoype:
%   d = return_PhD_distance(x,y,dist)
% 
% Inputs:
%   x       - a target feature vector
%   y       - a query feture vector
%   dist    - a string identitifer determining the type similarity function
%                       dist = 'cos' | 'euc' | 'ctb' | 'mahcos'
%   covar   - the inverse of the covariance matrix of the trainign samples
%             (required only for mahcos) - I do not perform any parameter
%             checking!!!!!
% 
% Outputs:
%   d       - the computed "distance" between x and y
% 
% Notes:
% In each case a small distance means a similar sample a large distance means
% a dissimilar smaple
% 
function d = return_PhD_distance(x,y,dist,covar)

if nargin==3
    [a,b]=size(x);
    covar = eye(a,a);
end

%I assume that x and y are column vectors
if strcmp(dist,'euc')==1
    d = norm(x-y);
elseif strcmp(dist,'ctb')==1
    d = sum(abs(x-y));
elseif strcmp(dist,'cos')==1
    norm_x = norm(x);
    norm_y = norm(y);
    d = - (x'*y)/(norm_x*norm_y);
elseif strcmp(dist,'mahcos')==1
    norm_x = sqrt(x'*covar*x);
    norm_y = sqrt(y'*covar*y);
    d = - (x'*covar*y)/(norm_x*norm_y);
else
    disp('The specified distance is not supported!')
    return;
end




