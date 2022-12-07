% ##     ## ##          ##          ###    ########    ###    ##    ## ######## ######## ######## ########
% ##     ## ##          ##         ## ##   ##         ## ##    ##  ##  ##          ##       ##    ##
% ##     ## ##          ##        ##   ##  ##        ##   ##    ####   ##          ##       ##    ##
% ##     ## ##          ##       ##     ## ######   ##     ##    ##    ######      ##       ##    ######
% ##     ## ##          ##       ######### ##       #########    ##    ##          ##       ##    ##
% ##     ## ##          ##       ##     ## ##       ##     ##    ##    ##          ##       ##    ##
%  #######  ########    ######## ##     ## ##       ##     ##    ##    ########    ##       ##    ########

%   _
%  |_ ._ _   _  ._ _  o ._   _
%  |_ | | | (/_ | (_| | | | (_|
%   _              _|        _|
%  /   _  ._ _  ._     _|_ o ._   _
%  \_ (_) | | | |_) |_| |_ | | | (_|
%  ___          |                 _|               _    _  ___
%   |  _   _ |_  ._   _  |  _   _  o  _   _       |_   /    | 
%   | (/_ (_ | | | | (_) | (_) (_| | (/_ _>   -   |_ . \_.  |  
%                               _/                       
%   |   _. |_
%   |_ (_| |_) o

% Res. Sci. Sercan AYGUN, Ph.D., under supervision Asst. Prof. M. Hassan NAJAFI, Ph.D.
% for further info: sercan.aygun@louisiana.edu

% Collaborators: To be filled

% Date: 12-06-2022 
% Version: 1.1. Training & Testing MNIST via HDC
% no fine tune,
% no retrain,
% no validation set

% For the sake of C/C++ conversion, no class & function def. utilized.
% Please keep eye on pre. memory allocation.

clear all
close all

[images_train, images_test, labels_test, labels_train, images_train_SC, images_test_SC]= mnist_db_construct();
images_train = double(images_train);
images_test = double(images_test);

image_row_size = 28;
image_column_size = 28;

%TRAIN_IMAGE_INDEX = 1; %To be parametrized

trainDB_size = 1; %a dummy parameter
numberOfClasses = 10;
total_training_images = 1000;

D = 4096; %vector dimension

%8-bit gray-scale
low_intensity = 0;
high_intensity = 255;

M = high_intensity+1; %quantization interval

%Static threshold for position hypervector vectors, P, orthogonal
threshold = ((high_intensity+1)/2); %Half value of max. intensity value; mid value

%Dynamic threshold parameter for level hypervector vectors, L, correlated
bitflip_count = D/(M); %note that D >= 2*high_intensity

%rows are pixel
%columns are images

%EXAMPLE of figure reshaping
%-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@
% figure
% for i = 1:100
% subplot(10,10,i)
% digit = reshape((images_train(:, i)), [28,28]);
% imshow(digit)
% title(num2str(labels_train(i)))
% end
%-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@
%Single image example
%reshape((images_train(:, 1)), [28,28]);
%-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@-@
%DB inputs up to that point
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%Generating a position hypervectors P
%Allocate mem.
P_hypervector = zeros(image_row_size, image_column_size, D);

%-----------------------First RANDOM Method--------------------------------

% r = round((high_intensity-low_intensity).*rand(28,28,D) + low_intensity);
% %r is random vector for position hypervectors
% for i = 1:1:image_row_size
%     for j = 1:1:image_column_size
%         for z = 1:1:D
%             if threshold <= r(i,j,z)
%                 P_hypervector(i,j,z) = -1;
%             end
%             if threshold > r(i,j,z)
%                 P_hypervector(i,j,z) = 1;
%             end
%         end
%     end
% end

%-----------------------First RANDOM Method--------------------------------

%-----------------------Second SOBOL Method--------------------------------
%Sobol LD Contribution

sobol_sequences = net(sobolset(28*28),(D));
sobol_sequences = transpose(sobol_sequences);
sobol_sequences = reshape(sobol_sequences, [28,28,D]);
threshold = 0.5; %update threshold

for i = 1:1:image_row_size
    for j = 1:1:image_column_size
        for z = 1:1:D
            if threshold <= sobol_sequences(i,j,z)
                P_hypervector(i,j,z) = -1;
            end
            if threshold > sobol_sequences(i,j,z)
                P_hypervector(i,j,z) = 1;
            end
        end
    end
end

%-----------------------Second SOBOL Method--------------------------------

%--------------------------------------------------------------------------
%P control ---> p_control = reshape(P_hypervector(1,1,:), [1,D])

%%
%TRAINING STARTS
cumulative_class_hypervector = zeros(numberOfClasses,D);
for TRAIN_IMAGE_INDEX = 1:1:total_training_images %50 will be total db size

    %--------------------------------------------------------------------------
    %--------------------------------------------------------------------------
    %Generating level hypervectors L
    %feature size is image_row * image_column

    %Pre-process dataset
    shaped_images = zeros(trainDB_size, image_row_size, image_column_size);

    % for i = 1:1:trainDB_size
    %     shaped_images(i,:,:) = reshape(images_train(:, i), [1,28,28]);
    % end

    shaped_images(1,:,:) = reshape(images_train(:, TRAIN_IMAGE_INDEX), [1,28,28]);

    %single image shaping ---> reshape(shaped_images(1,:,:), [28,28])

    %shaped_images
    % 3-dimensional vector (currently) ---> image index * row * column

    %Image quantization if needed (be aware to update low & high intensities & M value, even maybe the D value)
    %shaped_images = floor(shaped_images ./ 32);

    %Level hypervectors
    %Allocate mem.
    %vectorized_Images = zeros(trainDB_size, image_row_size, image_column_size, D);



    if TRAIN_IMAGE_INDEX == 1 %Only one-time generation

        initial_vector_seed = ones(1,D);
        intensity_vector = ones(M,D);

        %This is for the grayscale-based intensity encoding (correlated)
        iter = 1; %iteration for the total bitflips do not affect the previous bitflips
        for k=1:1:M %k = 1.....256 (0...255 pixel values)
            while iter <= bitflip_count
                rand_pos = round((D-1).*rand(1,1) + (1));
                if initial_vector_seed(rand_pos) == 1
                    initial_vector_seed(rand_pos) = -1;
                    iter = iter + 1;
                end
            end
            intensity_vector(k,:) = initial_vector_seed;
            iter = 1;
        end

    end %end of one-time control if

    %intensity has M * D size, where M is the quantized intervals (total different pixel values --> 0...255 etc.)
    % intensity_vector(1,:) --> 1 1 1 ... 1
    % and
    % intensity_vector(M,:) --> 0 0 0 ... 0 for 1-bitflip_count at each level

    %--------------------------------------------------------------------------
    %XOR (i.e. multiplication)
    %----------------------------BINDING---------------------------------------
    %Allocate mem.
    xored_Images = zeros(trainDB_size, image_row_size, image_column_size, D);

    for item_image=1:1:trainDB_size %iterating over training images
        for i=1:1:image_row_size
            for j = 1:1:image_column_size
                temp = reshape(P_hypervector(i,j,:), [1,D]) .* intensity_vector(shaped_images(item_image,i,j)+1,:);
                xored_Images(item_image, i, j, :) = reshape(temp, [1,1,1,D]);
            end
        end
    end

    %xor_Control = reshape(xored_Images(1,1,1,:), [1,D]);
    %--------------------------------------------------------------------------


    %--------------------------------------------------------------------------
    %ADD
    %----------------------------BUNDLING--------------------------------------
    %Allocate mem.
    bundled = zeros(trainDB_size, D);

    for item_image=1:1:trainDB_size %iterating over training images
        for i=1:1:image_row_size
            for j = 1:1:image_column_size
                bundled(item_image, :) = bundled(item_image, :) + reshape(xored_Images(item_image, i, j, :), [1,D]);
            end
        end
    end
    %--------------------------------------------------------------------------


    %--------------------------------------------------------------------------
    %SIGN
    %----------------------------BINARIZING------------------------------------
    %Allocate mem.
    bundled_signed = sign(bundled);
    %Exception handling for `0` values
    for z = 1:1:D
        if bundled_signed(z) == 0 %0 is 1 for us
            bundled_signed(z) = 1;
        end
    end
    %--------------------------------------------------------------------------

    %--------------------------------------------------------------------------
    %-------------------------CLASS HYPERVECTOR--------------------------------
    %Allocate mem.
    %cumulative_class_hypervector = zeros(numberOfClasses,D); %temporary assignment

    cumulative_class_hypervector(labels_train(TRAIN_IMAGE_INDEX)+1,:) = cumulative_class_hypervector(labels_train(TRAIN_IMAGE_INDEX)+1,:) + bundled_signed;

end

%---------------------------CLASS HYPERVECTOR SIGN-------------------------
signed_class_hypervector = sign(cumulative_class_hypervector);

%zero correction
zero_index = find(~signed_class_hypervector);
zero_index_size = size(zero_index);
for z = 1:1:zero_index_size
    signed_class_hypervector(zero_index(z)) = 1;
end
%---------------------------CLASS HYPERVECTOR SIGN-------------------------

%          signed_class_hypervector is the model for inference

%                              END of TRAING
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%##########################################################################
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


%%
%                                INFERENCE
accuracy = 0;
total_test_images = 200;
for TESTING_IMAGE_INDEX = 1:1:total_test_images %50 will be total db size

    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    %Generating level hypervectors L
    %feature size is image_row * image_column

    %Pre-process dataset
    shaped_images = zeros(trainDB_size, image_row_size, image_column_size);

    % for i = 1:1:trainDB_size
    %     shaped_images(i,:,:) = reshape(images_train(:, i), [1,28,28]);
    % end

    shaped_images(1,:,:) = reshape(images_test(:, TESTING_IMAGE_INDEX), [1,28,28]);


    %single image shaping ---> reshape(shaped_images(1,:,:), [28,28])

    %shaped_images
    % 3-dimensional vector (currently) ---> image index * row * column


    %Image quantization if needed (be aware to update low & high intensities & M value, even maybe the D value)
    %shaped_images = floor(shaped_images ./ 32);

    %Level hypervectors
    %Allocate mem.
    %vectorized_Images = zeros(trainDB_size, image_row_size, image_column_size, D);


    %intensity has M * D size, where M is the quantized intervals (total different pixel values --> 0...255 etc.)
    % intensity_vector(1,:) --> 1 1 1 ... 1
    % and
    % intensity_vector(M,:) --> 0 0 0 ... 0 for 1-bitflip_count at each level

    %----------------------------------------------------------------------
    %XOR (i.e. multiplication)
    %----------------------------BINDING-----------------------------------
    %Allocate mem.
    xored_Images = zeros(trainDB_size, image_row_size, image_column_size, D);

    for item_image=1:1:trainDB_size %iterating over training images
        for i=1:1:image_row_size
            for j = 1:1:image_column_size
                temp = reshape(P_hypervector(i,j,:), [1,D]) .* intensity_vector(shaped_images(item_image,i,j)+1,:);
                xored_Images(item_image, i, j, :) = reshape(temp, [1,1,1,D]);
            end
        end
    end

    %xor_Control = reshape(xored_Images(1,1,1,:), [1,D]);
    %--------------------------------------------------------------------------


    %--------------------------------------------------------------------------
    %ADD
    %----------------------------BUNDLING--------------------------------------
    %Allocate mem.
    bundled = zeros(trainDB_size, D);

    for item_image=1:1:trainDB_size %iterating over training images
        for i=1:1:image_row_size
            for j = 1:1:image_column_size
                bundled(item_image, :) = bundled(item_image, :) + reshape(xored_Images(item_image, i, j, :), [1,D]);
            end
        end
    end
    %----------------------------------------------------------------------


    %----------------------------------------------------------------------
    %SIGN
    %----------------------------BINARIZING--------------------------------
    %Allocate mem.
    bundled_signed = sign(bundled);
    %Exception handling for `0` values
    for z = 1:1:D
        if bundled_signed(z) == 0 %0 is 1 for us
            bundled_signed(z) = 1;
        end
    end
    %----------------------------------------------------------------------

    %CLASSIFICATION
    cosAngle = zeros(1, numberOfClasses);
    for classes = 1:1:numberOfClasses
        cosAngle(classes) = dot(bundled_signed(1,:), signed_class_hypervector(classes,:))/(norm(bundled_signed(1,:))*norm(signed_class_hypervector(classes, :)));
    end

    [value, position] = max(cosAngle);

    if position == (labels_test(TESTING_IMAGE_INDEX)+1)
        accuracy = accuracy + 1;
    end

end

classification_percentage = (accuracy * 100) / total_test_images