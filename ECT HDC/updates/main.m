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

D = 1024; %vector dimension

%8-bit gray-scale
low_intensity = 0;
high_intensity = 255;

M = high_intensity+1; %quantization interval

initial_vector_seed = ones(1,D);
intensity_vector = ones(M,D);

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

r = round((high_intensity-low_intensity).*rand(28,28,D) + low_intensity);
%r is random vector for position hypervectors
for i = 1:1:image_row_size
    for j = 1:1:image_column_size
        for z = 1:1:D
            if threshold <= r(i,j,z)
                P_hypervector(i,j,z) = -1;
            end
            if threshold > r(i,j,z)
                P_hypervector(i,j,z) = 1;
            end
        end
    end
end

%-----------------------First RANDOM Method--------------------------------

%-----------------------Second SOBOL Method--------------------------------
%Sobol LD Contribution

sobol_sequences = net(sobolset(28*28),(D));
sobol_sequences = transpose(sobol_sequences);
sobol_sequences = reshape(sobol_sequences, [28,28,D]);
threshold = 0.5; %update threshold

% for i = 1:1:image_row_size
%     for j = 1:1:image_column_size
%         for z = 1:1:D
%             if threshold <= sobol_sequences(i,j,z)
%                 P_hypervector(i,j,z) = -1;
%             end
%             if threshold > sobol_sequences(i,j,z)
%                 P_hypervector(i,j,z) = 1;
%             end
%         end
%     end
% end

%-----------------------Second SOBOL Method--------------------------------

%--------------------------------------------------------------------------
%P control ---> p_control = reshape(P_hypervector(1,1,:), [1,D])


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
    %intensity has M * D size, where M is the quantized intervals (total different pixel values --> 0...255 etc.)
    % intensity_vector(1,:) --> 1 1 1 ... 1
    % and
    % intensity_vector(M,:) --> 0 0 0 ... 0 for 1-bitflip_count at each level

%%

%Status bar
WaitMessage = parfor_wait(total_training_images, 'Waitbar', true);

%TRAINING STARTS
cumulative_class_hypervector = zeros(numberOfClasses,D);

cumulative_class_hypervector0 = zeros(1,D);
cumulative_class_hypervector1 = zeros(1,D);
cumulative_class_hypervector2 = zeros(1,D);
cumulative_class_hypervector3 = zeros(1,D);
cumulative_class_hypervector4 = zeros(1,D);
cumulative_class_hypervector5 = zeros(1,D);
cumulative_class_hypervector6 = zeros(1,D);
cumulative_class_hypervector7 = zeros(1,D);
cumulative_class_hypervector8 = zeros(1,D);
cumulative_class_hypervector9 = zeros(1,D);

tic
for TRAIN_IMAGE_INDEX = 1:total_training_images %50 will be total db size

    %--------------------------------------------------------------------------
    %Status bar odds
    % Update waitbar and message
    WaitMessage.Send;
    pause(0.002);
    %--------------------------------------------------------------------------

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
    
    %EITHER----------------------------------------------------------------
    %The following was a better choice for cumulative_class_hypervector, but parfor gets angry :(
    %cumulative_class_hypervector(labels_train(TRAIN_IMAGE_INDEX)+1,:) = cumulative_class_hypervector(labels_train(TRAIN_IMAGE_INDEX)+1,:) + bundled_signed;
    %EITHER----------------------------------------------------------------

    %OR--------------------------------------------------------------------
    if labels_train(TRAIN_IMAGE_INDEX) == 0
        cumulative_class_hypervector0 = cumulative_class_hypervector0 + bundled_signed;
    end
    if labels_train(TRAIN_IMAGE_INDEX) == 1
        cumulative_class_hypervector1 = cumulative_class_hypervector1 + bundled_signed;
    end
    if labels_train(TRAIN_IMAGE_INDEX) == 2
        cumulative_class_hypervector2 = cumulative_class_hypervector2 + bundled_signed;
    end
    if labels_train(TRAIN_IMAGE_INDEX) == 3
        cumulative_class_hypervector3 = cumulative_class_hypervector3 + bundled_signed;
    end
    if labels_train(TRAIN_IMAGE_INDEX) == 4
        cumulative_class_hypervector4 = cumulative_class_hypervector4 + bundled_signed;
    end
    if labels_train(TRAIN_IMAGE_INDEX) == 5
        cumulative_class_hypervector5 = cumulative_class_hypervector5 + bundled_signed;
    end
    if labels_train(TRAIN_IMAGE_INDEX) == 6
        cumulative_class_hypervector6 = cumulative_class_hypervector6 + bundled_signed;
    end
    if labels_train(TRAIN_IMAGE_INDEX) == 7
        cumulative_class_hypervector7 = cumulative_class_hypervector7 + bundled_signed;
    end
    if labels_train(TRAIN_IMAGE_INDEX) == 8
        cumulative_class_hypervector8 = cumulative_class_hypervector8 + bundled_signed;
    end
    if labels_train(TRAIN_IMAGE_INDEX) == 9
        cumulative_class_hypervector9 = cumulative_class_hypervector9 + bundled_signed;
    end
    %OR--------------------------------------------------------------------

end %end of training iteration
toc
WaitMessage.Destroy %close status bar

%OR--------------------------------------------------------------------
cumulative_class_hypervector = cat(1, cumulative_class_hypervector0, cumulative_class_hypervector1, cumulative_class_hypervector2, ...
    cumulative_class_hypervector3, cumulative_class_hypervector4, cumulative_class_hypervector5, cumulative_class_hypervector6, ...
    cumulative_class_hypervector7, cumulative_class_hypervector8, cumulative_class_hypervector9);
%OR--------------------------------------------------------------------


%BINARY--------------------------------------------------------------------
%---------------------------CLASS HYPERVECTOR SIGN-------------------------
signed_class_hypervector = sign(cumulative_class_hypervector);

%zero correction
zero_index = find(~signed_class_hypervector);
zero_index_size = size(zero_index);
for z = 1:1:zero_index_size
    signed_class_hypervector(zero_index(z)) = 1;
end
%---------------------------CLASS HYPERVECTOR SIGN-------------------------


%NON-BINARY--------------------------------------------------------------------
%---------------------------CLASS HYPERVECTOR SIGN-------------------------
%signed_class_hypervector = cumulative_class_hypervector;
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

%TESTING STARS
%Status bar
h = waitbar(0,'TESTING');

accuracy = 0;
total_test_images = 100;
for TESTING_IMAGE_INDEX = 1:1:total_test_images %50 will be total db size
    
    %--------------------------------------------------------------------------
    %Status bar odds
    % Update waitbar and message
    waitbar(TESTING_IMAGE_INDEX/total_test_images,h)
    %--------------------------------------------------------------------------

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

end %end of testing for 
delete(h);

classification_percentage = (accuracy * 100) / total_test_images