#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "ofxOpenCv.h"
#include "ofxFft.h"

#include "oscillator.h"

class ofApp : public ofxiOSApp {
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
	
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);

        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);

    private:
    void calculateFrameHistogram(cv::Mat input, float *histogram);
    void generateSignal(float *histogram, float *buffer);
    
    ofVideoGrabber vidGrabber;
    
    ofTexture tex;
    
    ofxCvColorImage	colorImg;
    
    ofxCvGrayscaleImage grayImage;
    ofxCvGrayscaleImage scaledInputImage;
//    ofxCvGrayscaleImage enlarged;
    ofxCvColorImage enlarged;
    
    
    ofxCvGrayscaleImage grayBg;
    ofxCvGrayscaleImage grayDiff;
    
    float capW;
    float capH;



    void audioOut(float * output, int bufferSize, int nChannels);
    float pan;
    int sampleRate;
    bool bNoise;
    float volume;
    
    float * lAudio;
    float * rAudio;

    //------------------- for the simple sine wave synthesis
    float targetFrequency;
    float phase;
    float phaseAdder;
    float phaseAdderTarget;
    int initialBufferSize;
    
    
	ofMutex soundMutex;
    
    float *histogramArray;

    Oscillator *oscillators;
    
    float *outputSignal;
};


