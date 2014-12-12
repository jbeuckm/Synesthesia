#include "ofApp.h"
#include "ofxFft.h"

using namespace cv;

//--------------------------------------------------------------
void ofApp::setup(){
    //ofSetOrientation(OF_ORIENTATION_90_RIGHT);//Set iOS to Orientation Landscape Right
    
    capW = 320;
    capH = 240;
    
    vidGrabber.initGrabber(capW, capH);
    capW = vidGrabber.getWidth();
    capH = vidGrabber.getHeight();
    
    colorImg.allocate(capW,capH);
    grayImage.allocate(capW,capH);
    scaledInputImage.allocate(capW/8, capH/8);
    enlarged.allocate(capW,capH);
    
    grayBg.allocate(capW,capH);
    grayDiff.allocate(capW,capH);
    
    ofSetFrameRate(20);



    // 0 input channels
    // 44100 samples per second
    // 512 samples per buffer
    // 4 num buffers (latency)
    
    sampleRate = 44100;
    phase = 0;
    phaseAdder = 0.0f;
    phaseAdderTarget = 0.0;
    volume = 0.15f;
    pan = 0.5;
    bNoise = true;
    
    //for some reason on the iphone simulator 256 doesn't work - it comes in as 512!
    //so we do 512 - otherwise we crash
    initialBufferSize = 1024;
    
    lAudio = new float[initialBufferSize];
    rAudio = new float[initialBufferSize];
    outputSignal = new float[initialBufferSize];
    histogramArray = new float[initialBufferSize];
    
    
    oscillators = (Oscillator *)(operator new[]( initialBufferSize * sizeof( Oscillator ) ));
    for (int i=0; i<initialBufferSize; i++) {
        oscillators[i] = Oscillator();
        oscillators[i].setFrequency(i*10);
    }

    memset(lAudio, 0, initialBufferSize * sizeof(float));
    memset(rAudio, 0, initialBufferSize * sizeof(float));
    memset(outputSignal, 0, initialBufferSize * sizeof(float));
    
    //we do this because we don't have a mouse move function to work with:
    targetFrequency = 444.0;
    phaseAdderTarget = (targetFrequency / (float)sampleRate) * TWO_PI;
    
    // This call will allow your app's sound to mix with any others that are creating sound
    // in the background (e.g. the Music app). It should be done before the call to
    // ofSoundStreamSetup. It sets a category of "play and record" with the "mix with others"
    // option turned on. There are many other combinations of categories & options that might
    // suit your app's needs better. See Apple's guide on "Configuring Your Audio Session".
    
    // ofxiOSSoundStream::setMixWithOtherApps(true);
    
//    ofSoundStreamSetup(2, 0, this, sampleRate, initialBufferSize, 4);

}

//--------------------------------------------------------------
void ofApp::update(){
    ofBackground(100,100,100);
    
    bool bNewFrame = false;
    
    vidGrabber.update();
    bNewFrame = vidGrabber.isFrameNew();

    if (bNewFrame){
        
        if( vidGrabber.getPixels() != NULL ){
            
            colorImg.setFromPixels(vidGrabber.getPixels(), capW, capH);
            enlarged.scaleIntoMe(colorImg, CV_INTER_AREA);


            calculateFrameHistogram(colorImg.getCvImage(), histogramArray);
/*
            soundMutex.lock();
            generateSignal(histogramArray, outputSignal);
            soundMutex.unlock();
*/
//            ofLog() << signal;
            
        }
    }
}

void ofApp::generateSignal(float *histogram, float *buffer) {
    
    for (int i=0; i<initialBufferSize; i++) {
        buffer[i] = 0;
    }

}



void ofApp::calculateFrameHistogram(Mat input, float *histogram) {
    
    Mat hsv_input;
    
    cvtColor( input, hsv_input, CV_BGR2HSV );
    
    int h_bins = 512;
    int histSize[] = { h_bins };
    float h_ranges[] = { 0, 180 };
    
    const float* ranges[] = { h_ranges };
    int channels[] = { 0 };
    
    MatND hist_input;
    
    //            calcHist( &hsv_input, 1, channels, Mat(), hist_input, 1, histSize, ranges, true, false );
    calcHist( &input, 1, channels, Mat(), hist_input, 1, histSize, ranges, true, false );
    
    normalize( hist_input, hist_input, 0, 1, NORM_MINMAX, -1, Mat() );
    
    memcpy(histogram, hist_input.data, h_bins * sizeof(float));
}


//--------------------------------------------------------------
void ofApp::audioOut(float * output, int bufferSize, int nChannels){
    
    if( initialBufferSize < bufferSize ){
        ofLog(OF_LOG_ERROR, "your buffer size was set to %i - but the stream needs a buffer size of %i", initialBufferSize, bufferSize);
        return;
    }
    
    float leftScale = 1 - pan;
    float rightScale = pan;
    
    // sin (n) seems to have trouble when n is very large, so we
    // keep phase in the range of 0-TWO_PI like this:
    while(phase > TWO_PI){
        phase -= TWO_PI;
    }
    
    if(bNoise == true){
        // ---------------------- noise --------------
        for(int i = 0; i < bufferSize; i++){
            lAudio[i] = output[i * nChannels] = outputSignal[i] * volume * leftScale;
            rAudio[i] = output[i * nChannels + 1] = outputSignal[i] * volume * rightScale;
        }
    } else {
        phaseAdder = 0.95f * phaseAdder + 0.05f * phaseAdderTarget;
        for(int i = 0; i < bufferSize; i++){
            phase += phaseAdder;
            float sample = sin(phase);
            lAudio[i] = output[i * nChannels] = sample * volume * leftScale;
            rAudio[i] = output[i * nChannels + 1] = sample * volume * rightScale;
        }
    }
    
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    ofSetColor(255);
    ofDrawBitmapString(ofToString(ofGetFrameRate()), 20, 20);
    
    ofPushMatrix();

    //	ofScale(scale, scale, 1);
    
    // draw the incoming, the grayscale, the bg and the thresholded difference
    ofSetHexColor(0xffffff);
    enlarged.draw(0,0);
    //	grayImage.draw(0,40);
    //	grayBg.draw(capW+4, 0);
    //	grayDiff.draw(0, capH + 4);
    
    //	ofPopMatrix();
    // finally, a report:
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}
