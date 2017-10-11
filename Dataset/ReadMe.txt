If you use this dataset in your research publications, please cite our paper:
"Image Matching Benchmark. JiaWang Bian, Le Zhang, Yun Liu, Wen-Yan Lin, Ming-Ming Cheng and Ian D. Reid"

Data format in the dataset:
1. The folder "Dataset" contains total 8 subfolders.
2. There exist "Images/", "camera.txt", "pairs.txt", and "Results/"("Results2") in each subset.
3. "Images/" is the path of images, and it also contains a file "pose.txt". 
   The "pose.txt" saves a matrix with n rows and 12 colmuns, where n is the number of images, and each row records the camera extrinsic parameter of an image. 
   The pose should include 4x4=16 elements, and we only save the first 3x4=12 elements because the last row of pose is always "0 0 0 1".
4. "camera.txt" saves a 3x3 matrix, which is the camera intrinsic parameter.
5. "pairs.txt" saves a matrix with 14 colmuns, and each row saves a pair of images that should be matched.
   The first colmun records the index of the first image, and the second colmun records the index of the second image.
   The next 12 colmuns represent the relative pose transformation between two images.
6. "Results/" contains algorithms' results under defaut parameter setting, and the results of matchers with changed parameters are saved in "Results2/".
   The file format in two folers are same. 
   A file (like "sift_ratio.txt") contains 15 colmuns, where the first two colmuns record the image pair, the third colmun record the number of verified correspondences, and the nex 12 colmuns record the estimated camera pose.
   