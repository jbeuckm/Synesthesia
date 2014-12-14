//
//  oscillator.h
//  Synesthesia
//
//  Created by joe on 12/12/14.
//
//

#ifndef Synesthesia_oscillator_h
#define Synesthesia_oscillator_h

class Oscillator {
    
public:
    Oscillator(int sampleRate);

    float stepSize;
    float position;
    int sampleRate;
    
    void setFrequency(float f);
    float getSample(float *waveTable);
};

#endif
