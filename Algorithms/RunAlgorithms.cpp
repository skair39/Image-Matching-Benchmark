// This file contains 4 (features) * 3 (matching methods) = 12 feature matchers
// Input :
// 	1. matcher's name
//  2. Dataset Directory
// Author :
//	JiaWang Bian

#include <iostream>
#include <fstream>
#include <opencv2/opencv.hpp>
#include <string>
#include <sys/stat.h>
#include <opencv2/xfeatures2d/nonfree.hpp>
#include <opencv2/xfeatures2d.hpp>
#include "gms_matcher.h"
#ifdef _WIN32
	#include <direct.h>
#endif

using namespace cv;
using namespace std;


void LoadPairs(const string &strFile, vector<Vec2i> &pairs);

void LoadCalibrations(const string &strCalibration, Mat &K);

int MatchImages(Mat img1, Mat img2, string features, string methods, Mat K, Mat &pose);



int main(int argc, char **argv){

	if(argc != 4)
    {
        cerr << endl << "Usage: ./RunAlgorithms FeatureName MethodName DatasetDir" << endl;
        cerr << "FeatureName : sift, surf, orb, akaze, brisk, kaze " << endl;
        cerr << "MethodName : ratio, gms" << endl;
        return 1;
    }

    string strFile = string(argv[3]) + "/pairs.txt";
    vector<Vec2i> pairs;
    LoadPairs(strFile, pairs);

    Mat K;
    string strCalibration = string(argv[3]) + "/camera.txt";
    LoadCalibrations(strCalibration, K);

    vector<int> ninliers(pairs.size());
    vector<Mat> vPoses(pairs.size());

    string strImagePath = string(argv[3]) + "/Images";
    for (size_t i = 0; i < pairs.size(); ++i)
    {
        int l = pairs[i][0];
        int r = pairs[i][1];

        char bufferl[50];  sprintf(bufferl, "/%04d.png", l);
        char bufferr[50];  sprintf(bufferr, "/%04d.png", r);

        Mat img1 = imread(strImagePath + string(bufferl), 0);
        Mat img2 = imread(strImagePath + string(bufferr), 0);

        ninliers[i] = MatchImages(img1, img2, string(argv[1]), string(argv[2]), K, vPoses[i]);
        cout << i << "/"<< pairs.size() << "\r";
    }

    // write results
    string ResultsDir = string(argv[3]) + "/Results";
#ifdef __linux__
	mkdir(ResultsDir.c_str(), S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
#elif _WIN32
	_mkdir(ResultsDir.c_str());
#endif

    string outputfiles =  ResultsDir + "/" + string(argv[1]) + "_" + string(argv[2]) + ".txt";
    ofstream ofs;
    ofs.open(outputfiles.c_str());
    for (size_t i = 0; i < vPoses.size(); ++i)
    {
        int l = pairs[i][0];
        int r = pairs[i][1];

        ofs << l <<" "<< r <<" "<< ninliers[i]<<" ";
        double *data = (double *)vPoses[i].data;

        for (int j = 0; j < 11; ++j)
        {
            ofs << data[j] <<" ";
        }
        ofs << data[11] <<endl;
    }
    ofs.close();

    return 0;
}


void LoadPairs(const string &strFile, vector<Vec2i> &pairs){
	ifstream f;
    f.open(strFile.c_str());

    pairs.reserve(10000);
    while(!f.eof())
    {
        string s;
        getline(f,s);
        if(!s.empty())
        {
            stringstream ss;
            ss << s;

            int l, r;
            ss >> l;
            ss >> r;
            
            Vec2i p;
            p[0] = l;
            p[1] = r;
            pairs.push_back(p);
        }
    }

    f.close();
}

void LoadCalibrations(const string &strCalibration, Mat &K){
    K = Mat::eye(3,3,CV_64FC1);

    ifstream f;
    f.open(strCalibration.c_str());

    double *data = (double *)K.data;

    while(!f.eof())
    {
        string s;
        getline(f,s);
        if(!s.empty())
        {
            stringstream ss;
            ss << s;

            double c;
            for (int j=0; j<3; ++j){
                ss >> c;
                *data++ = c;
            }
        }
    }
    f.close();
}

int MatchImages(Mat img1, Mat img2, string features, string methods, Mat K, Mat &pose){

    Ptr<Feature2D> extractor;
    Ptr<DescriptorMatcher> matcher;


    if (features == string("sift"))
    {
        extractor = xfeatures2d::SIFT::create();
        matcher = FlannBasedMatcher::create();
    }
    if (features == string("surf"))
    {
        extractor = xfeatures2d::SURF::create();
        matcher = FlannBasedMatcher::create();
    }
    if (features == string("orb"))
    {
        extractor = ORB::create(100000);
        matcher = BFMatcher::create(NORM_HAMMING);
    }
    if (features == string("akaze"))
    {
        extractor = AKAZE::create();
        matcher = BFMatcher::create(NORM_HAMMING);
    }
    if (features == string("kaze")){
        extractor = KAZE::create();
        matcher = FlannBasedMatcher::create();
    }
    if (features == string("brisk")){
        extractor = BRISK::create();
        matcher = BFMatcher::create(NORM_HAMMING);
    }

    // extract features
    vector<KeyPoint> kp1, kp2;
    Mat d1, d2;

    extractor->detectAndCompute(img1,Mat(),kp1,d1);
    extractor->detectAndCompute(img2,Mat(),kp2,d2);

    // nearest-neighbor matching
    vector<DMatch> vMatches, vMatchesAll;
    vector<vector<DMatch> > vMatchesKnn;

    // correspondence selection
    if(methods == "ratio"){
        matcher->knnMatch(d1,d2,vMatchesKnn,2);
        vMatches.reserve(vMatchesKnn.size());

        for (size_t i = 0; i < vMatchesKnn.size(); ++i)
        {
            if(vMatchesKnn[i][0].distance < vMatchesKnn[i][1].distance * 0.8){
                vMatches.push_back(vMatchesKnn[i][0]);
            }
        }
    }


    if(methods == "gms"){
        matcher->match(d1,d2,vMatchesAll);
        vMatches.reserve(vMatchesAll.size());

        // GMS filter
        vector<bool> vbInliers;
        gms_matcher gms(kp1,img1.size(), kp2, img2.size(), vMatchesAll);
        int num_inliers = gms.GetInlierMask(vbInliers, false, false);

        // collect
        for (size_t i = 0; i < vbInliers.size(); ++i)
        {
            if (vbInliers[i] == true)
            {
                vMatches.push_back(vMatchesAll[i]);
            }
        }
    }


    // geometry verification
    pose = Mat::eye(4,4,CV_64FC1);

    if (vMatches.size() < 20)
        return 0;

    vector<Point2f> vp1(vMatches.size()), vp2(vMatches.size());
    for (size_t i = 0; i < vMatches.size(); ++i)
    {
        vp1[i].x = kp1[vMatches[i].queryIdx].pt.x;
        vp1[i].y = kp1[vMatches[i].queryIdx].pt.y;
    
        vp2[i].x = kp2[vMatches[i].trainIdx].pt.x;
        vp2[i].y = kp2[vMatches[i].trainIdx].pt.y;
    }

    Mat E = findEssentialMat(vp1, vp2, K);

    if (E.empty())
        return 0;

    Mat R, t;
    int ninliers = recoverPose(E, vp1, vp2, K, R, t); 

    if(ninliers < 10)
        return 0;

    R.copyTo(pose(Rect(0, 0, 3, 3)));
    t.copyTo(pose(Rect(3, 0, 1, 3)));

    return ninliers;
}
