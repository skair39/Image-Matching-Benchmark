# Image Matching Benchmark
Evaluation code for "Image Matching Benchmark"

![alt tag](https://jwbian.net/wp-content/uploads/2017/09/Pipeline.png)

## Publication:

**Image Matching Benchmark**, JiaWang Bian, Le Zhang, Yun Liu, Wen-Yan Lin, Ming-Ming Cheng and Ian D. Reid.
[[Project Page](http://jwbian.net/benchmark)] [[pdf](https://arxiv.org/abs/1709.03917)] [[Dataset (BaiduYun)](http://pan.baidu.com/s/1c22HIFI)]


## Usage

Requirements:

	1. Matlab (Evaluate results and plot figures)
	2. Ghostscript (save figures as pdf format)

Dataset:
	
	1. Download the all subsets from the project page (https://jwbian.net/benchmark) and put them in the folder "Dataset".
	2. "ReadMe.txt" in "Dataset" folder gives description of data format, including the groundtruth and your output results
    
    
Evaluation:
	
	1. Run "PlotResults.m" to evaluate the results in folder "/Results" and save figures in "/Curves".
	2. Run "PlotResults2.m" to evaluate the results in folder "/Results2" and save figures in "/Curves2".
    

## If you like this work, please cite our paper
	@inproceedings{bian2018benchmark,
 	    title={Image Matching Benchmark},
	    author={JiaWang Bian and Le Zhang and Yun Liu and Wen-Yan Lin and Ming-Ming Cheng and Ian D. Reid},
	    year={2018}
	}



