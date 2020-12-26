
PImage img;

void setup(){
  size(512, 256);
  img = loadImage("Sample2.png");
  img.resize(256, 256);
  //test--
  //Complex[][] x = {{r(1), r(3.6)}, {r(1), r(8)}, {r(1), r(3.6)}, {r(1), r(8)}};
  //twoD_FFT(x);
  //twoD_IFFT(x);
  //println(x[0][0], x[0][1], x[1][0], x[1][1], x[2][0], x[2][1], x[3][0], x[3][1]);
}

void draw(){
  //base data from image brightness-----
  Complex[][] comp = new Complex[256][256];
  for(int i = 0; i<256; i++){
    for(int j = 0; j<256; j++){
      comp[i][j] = r(brightness(img.pixels[i+j*256]));
    }
  }
  
  //make gaussian kernel-----
  float blurS = map(mouseX, 0, width, 1, 100);//blur size
  Complex[][] gk = gaussK(256, 256./blurS);//gaussian kernel
  
  //Fourier transform data and gaussian kernel and multiply them.-----
  twoD_FFT(comp);//fft and update
  twoD_FFT(gk);
  comp = mult(comp, gk);//comp = comp*gk;
  
  //inverse fourier transform and shift it.-----
  twoD_IFFT(comp);//inverse fft and update
  comp = FFT_Shift(comp);//shift result
  
  //show result-----
  noStroke();
  for(int i = 0; i<256; i++){
    for(int j = 0; j<256; j++){
      fill(comp[i][j].x);
      rect(i+256, j, 1, 1);
      fill(brightness(img.pixels[i+j*256]));
      rect(i, j, 1, 1);
    }
  }
}
