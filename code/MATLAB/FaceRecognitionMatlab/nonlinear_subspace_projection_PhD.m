

function feat = nonlinear_subspace_projection_PhD(X, model);

%% Init
feat=[];

%% Check inputs

%check number of inputs
if nargin <2
    disp('Wrong number of input parameters! The function requires two input arguments.')
    return;
elseif nargin >2
    disp('Wrong number of input parameters! The function requires two input arguments.')
    return;
elseif nargin==2
    %get size of testing data
    [a,b]=size(X);
    
    %check model 
    if isfield(model, 'W')~=1
        disp('There is no subspace basis defined. Missing model.W!')
        return;
    end
    
    if isfield(model,'dim')~=1
        disp('There is no subspace dimensionality defined. Missing model.dim!')
        return;
    end
    
    if isfield(model,'eigs')~=1
        disp('There are no eigenvalues associated with the subspace basis. Missing model.eigs!')
        return;
    end
    
    if isfield(model,'train')~=1
        disp('There are no training features defined. Missing model.train!')
        return;
    end
    
    if isfield(model,'J')~=1
        disp('There is no auxilary matrix defined. Missing model.J!')
        return;
    end
    
    if isfield(model,'K')~=1
        disp('There is no training kernel matrix defined. Missing model.K!')
        return;
    end
    
    if isfield(model,'typ')~=1
        disp('There is no kernel type defined. Missing model.typ!')
        return;
    end
    
    if isfield(model,'args')~=1
        disp('There are no kernel arguments defined. Missing model.args!')
        return;
    end
    
    
    %check that the test and trainnig data are of the same dimensionality
    [c,d]=size(model.X);
    if c~=a
        disp('The dimensionality of the training and test data must be the same.')
        return;
    end
end

%% Print info to command prompt and init. operations
[c,d]=size(model.J);

%we assume that the data is contained in the columns
% disp(sprintf('The training data comprises %i samples (images) with %i variables (pixels).', b, a))
% disp('If this should be the other way around, please transpose the training-data matrix.')


%% Compute the test features

%compute the test kernel matrix
K = compute_kernel_matrix_PhD(X,model.X,model.typ,model.args);

%center the test kernel matrix
Jt=ones(b,1)/c;
J=ones(c,1);
K=K-((Jt*J')*model.K)-(K*(1/c)*(J*J'))+(Jt*J'*model.K*(1/c)*(J*J'));

%need to transpose the result - because of kernel matrix comptatioon
K=K';

%feature computation
feat = model.W'*K;

































