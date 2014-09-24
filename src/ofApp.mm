#include "ofApp.h"
#include "ofxFft.h"

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
            
            grayImage = colorImg;
            grayImage.contrastStretch();
            
            scaledInputImage.scaleIntoMe(grayImage);
            
            enlarged.scaleIntoMe(scaledInputImage, CV_INTER_AREA);
            
            // take the abs value of the difference between background and incoming and then threshold:
            //			grayDiff.absDiff(grayBg, grayImage);
            
        }
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    ofSetColor(255);
    ofDrawBitmapString(ofToString(ofGetFrameRate()), 20, 20);
    
    ofPushMatrix();
    float scale = 768.0 / 40.0;
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
