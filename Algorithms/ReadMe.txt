If you use this dataset in your research publications, please cite our paper:
"Image Matching Benchmark. JiaWang Bian, Le Zhang, Yun Liu, Wen-Yan Lin, Ming-Ming Cheng and Ian D. Reid"

In the folder "Algorithms":
	1. You need compile c++ code firstly, where both Windows and Linux platforms are supported.
	2. Then you can run "RunAlgorithm.m", and please correct the exe path if it is not as same as your path.

Compile C++ code:
	1. Create a folder "build".
	2. On Linux platform, you can use "cmake -DCMAKE_BUILD_TYPE=Release ../" and then "make".
	3. On Windows platform, you can use CMake with Visual Studio. Please make sure that you use "Release" Mode.
	4. You should also notice the path of "OpenCV" on your computer.
	