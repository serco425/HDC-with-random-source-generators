
function [images_train, images_test, labels_test, labels_train, images_train_SC, images_test_SC]= mnist_db_construct();

%DETERMINISTIC DATA
%load functions are referenced from: http://ufldl.stanford.edu/wiki/index.php/Using_the_MNIST_Dataset
images_train = loadMNISTImages('train-images.idx3-ubyte');
labels_train = loadMNISTLabels('train-labels.idx1-ubyte');
images_test = loadMNISTImages('t10k-images.idx3-ubyte');
labels_test = loadMNISTLabels('t10k-labels.idx1-ubyte');

%STOCHASTIC DATA
%[images_train_SC, images_test_SC]= DO_mnist_stochastic_stream(images_train, images_test, package_size, number_of_possible_in_TEST);

 images_test_SC = 1;
 images_train_SC = 1;

%Below is referenced from: http://kkms.org/index.php/kjm/article/viewFile/659/411
%To view the images (first 100) comment out the following --->
% figure
% for i = 1:100
% subplot(10,10,i)
% digit = reshape((images_train(:, i)), [28,28]);
% imshow(digit)
% title(num2str(labels_train(i)))
% end





end

