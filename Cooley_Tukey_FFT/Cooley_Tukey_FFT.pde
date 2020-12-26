import ddf.minim.*;
import ddf.minim.analysis.*;
import java.util.Arrays;

int Samples = 512;
Minim minim;
AudioInput in;
FFT fft;
MYFFT myfft = new MYFFT(Samples);
DFT dft = new DFT(Samples);

void setup() {
  size(1024, 400);
  //fullScreen();
  background(255);

  minim = new Minim(this);
  //textFont(createFont("Calibri-Bold-24", 12));
  in = minim.getLineIn(Minim.STEREO, Samples);
  //fft = new FFT(in.bufferSize(), in.sampleRate());
  //fft.window(FFT.HAMMING);
  stroke(255);
  frameRate(30);
  colorMode(HSB);
  strokeWeight(2);
}

void draw(){
  background(0);
  
  //fft.forward(in.mix);
  float[] input = new float[Samples];
  Complex[] input2 = new Complex[Samples];
  for (int i = 0;i < Samples; i++) {
    input[i] = in.left.get(i);
    input2[i] = c(in.left.get(i));
  }
  long startTime = System.nanoTime();
  ditfft2(input2);//fft & update input2
  println(System.nanoTime() - startTime);
  long startTime2 = System.nanoTime();
  float[] result = myfft.GetSpectrum(input);
  println(System.nanoTime() - startTime2);
  println("------");
  for (int i = 0;i < Samples; i++) {
    float x = map(i, 0, Samples, 0, width);
    float h = map(i, 0, Samples, 0, 255);
    //stroke(255);
    //line(x, height, x, height - in.left.get(i) * height);
    stroke(h, 255, 255);
    line(x, height, x, height - result[i] * height/8);
    stroke(255);
    line(x, height, x, height - input2[i].abs()/2 * height/8);
    //line(x, height, x, height - fft.getBand(i) * height/4);
  }
}


void stop() {
  minim.stop();
  super.stop();
}

//easy to understand
void ditfft2(Complex[] x){//based on this site https://en.wikipedia.org/wiki/Cooley%E2%80%93Tukey_FFT_algorithm
  int N = x.length;
  if(N == 1){
    return;
  }else{//based on this site https://github.com/bubnicbf/Fast-Fourier-Transform-using-Cooley-Tukey-algorithm/blob/master/FFT.cpp
    Complex[] even = new Complex[N/2];
    Complex[] odd = new Complex[N/2];
    int index = 0;
    for(int i=0; i<N; i+=2)even[index++] = x[i];
    index = 0;
    for(int i=1; i<N; i+=2)odd[index++] = x[i];
    
    ditfft2(even);//update even
    ditfft2(odd);//update odd
    
    for(int k = 0; k < N/2; k++){
      Complex t = exp(c(-TWO_PI*k/N)).mult(odd[k]);
      x[k] = even[k].add(t);
      x[k+N/2] = even[k].sub(t);
    }
  }
}//result is updated x

//difficult to understand but faster
class MYFFT {
  int Samples;
  float[][] Twiddle;
  int[] Bitreverse;

  MYFFT(int Samples) {
    this.Samples = Samples;

    Twiddle = new float[2][Samples/2];
    for (int i = 0; i < Samples / 2; i++) {
      float arg = -2*PI/Samples*i;
      Twiddle[0][i] = cos(arg);
      Twiddle[1][i] = sin(arg);
    }
    Bitreverse = new int[Samples];
    for (int i = 0; i < Samples; i++) {
      int Order = i, Reverse = 0;
      for (int j = Samples/2; j >= 1; j /= 2) {
        Reverse += (Order % 2) * j;
        Order /= 2;
      }
      Bitreverse[i] = Reverse;
    }
  }

  float[] GetSpectrum(float[] waveSamples) {
    float[] wave_Re = new float[Samples], wave_Im = waveSamples;
    for (int i = 0; i < Samples; i++) {//bitreverse
      wave_Re[i] = wave_Im[Bitreverse[i]];
      wave_Im[Bitreverse[i]] = 0;
    }
    //butterfly operation
    for (int i = 1; i < Samples; i *= 2){
      for (int j = 0; j < Samples; j += i * 2){
        for (int k = 0; k < i; k++) {
          int a = j + k;
          int b = a + i;
          int w = Samples/(2*i)*k;
          float 
            ar = wave_Re[a] + wave_Re[b] * Twiddle[0][w] - wave_Im[b] * Twiddle[1][w], 
            ai = wave_Im[a] + wave_Re[b] * Twiddle[1][w] + wave_Im[b] * Twiddle[0][w], 
            br = wave_Re[a] - wave_Re[b] * Twiddle[0][w] + wave_Im[b] * Twiddle[1][w], 
            bi = wave_Im[a] - wave_Re[b] * Twiddle[1][w] - wave_Im[b] * Twiddle[0][w];
          wave_Re[a] = ar;
          wave_Im[a] = ai;
          wave_Re[b] = br;
          wave_Im[b] = bi;
        }
      }
    }
    for(int i = 0; i < Samples; i++)wave_Re[i] = sqrt(wave_Re[i]*wave_Re[i]+wave_Im[i]*wave_Im[i]);
    return wave_Re;
  }
}

class DFT{
  int Samples;
  
  DFT(int Samples){
    this.Samples = Samples;
  }
  
  float[] GetSpectrum(float[] waveSamples){
    float[] Spectrum = new float[Samples];
    
    for(int i = 0; i < Samples; i++){
      float re = 0, im = 0;
      for(int j = 0; j < Samples; j++){
        float arg = -2*PI/Samples*i*j;
        
        re += cos(arg) * waveSamples[j];
        im += sin(arg) * waveSamples[j];
      }
      Spectrum[i] = sqrt(re*re + im*im);
    }
    return Spectrum;
  }
}
