
function filtered_image = filter_image_with_Gabor_bank_PhD(image,filter_bank,down_sampling_factor);

%% Init ops
filtered_image = [];

%% Check inputs

%check number of inputs
if nargin <2
    disp('Wrong number of input parameters! The function requires at least two input arguments.')
    return;
elseif nargin >3
    disp('Wrong number of input parameters! The function takes at most three input arguments.')
    return;
elseif nargin==2
    down_sampling_factor = 64;
end

%check down-sampling factor
if isnumeric(down_sampling_factor)~=1
    disp('The down-sampling factor needs to be a numeric value between larger or equal than 1! Swithing to defaults: 64');
    down_sampling_factor=64;
end

if size(down_sampling_factor,1)==1 && size(down_sampling_factor,2)==1 && down_sampling_factor>=1
    %ok
else
    disp('The downsampling factor needs to be a single number, greater or equal to one!')
    return;
end

%check filter bank   
    if isfield(filter_bank,'spatial')~=1
        disp('Could not find filters in the spatial domain. Missing filter_bank.spatial!')
        return;
    end
    
    if isfield(filter_bank,'freq')~=1
        disp('Could not find filters in the frequency domain. Missing filter_bank.freq!')
        return;
    end
    
    if isfield(filter_bank,'orient')~=1
        disp('Could not determine angular resolution. Missing filter_bank.orient!')
        return;
    end
    
    if isfield(filter_bank,'scales')~=1
        disp('Could not determine frequency resolution. Missing filter_bank.scales!')
        return;
    end
    
    %check image and filter size
    [a,b]=size(image);
    [c,d]=size(filter_bank.spatial{1,1}); %lets look at the first
    
    if a==2*c && d==2*b
        disp('The dimension of the input image and Gabor filters do not match! Damn! Terminating!')
        return;
    end
    
%% Compute output size
[a,b]=size(image);
dim_spec_down_sampl = round(sqrt(down_sampling_factor));
new_size = [floor(a/dim_spec_down_sampl) floor(b/dim_spec_down_sampl)];

%% Filter image in the frequency domain
image_tmp = zeros(2*a,2*b);
image_tmp(1:a,1:b)=image;
image = fft2(image_tmp);

for i=1:filter_bank.scales
    for j=1:filter_bank.orient
        
        %filtering
        Imgabout = ifft2((filter_bank.freq{i,j}.*image));
        gabout = abs(Imgabout(a+1:2*a,b+1:2*b));  
        
        % if you prefer to compute the real or imaginary part of the
        % filtering, uncomment the approapriate line below; the return 
        % value of the function will then be changed accordingly 
%         gabout = real(Imgabout(a+1:2*a,b+1:2*b));
%         gabout = imag(Imgabout(a+1:2*a,b+1:2*b));
    
        %down-sampling (the proper way to go is to use resizing (interpolation!!), sampling introduces high frequencies)
        y=imresize(gabout,new_size,'bilinear');
        
        y=(y(:)-mean(y(:)))/std(y(:)); %we use zero mean unit variance normalization - even though histogram equalization and gaussianization works better
        % comment out the line above and use
        % this one if you want to map a normal distribution to the filtered
        % image instead of only adjusting the mean and variance (you 
        % need my INface toolbox for that)
        % y = fitt_distribution(y);    
        y=y(:);
        
        %add to image
        filtered_image=[filtered_image;y];     
    end
end














