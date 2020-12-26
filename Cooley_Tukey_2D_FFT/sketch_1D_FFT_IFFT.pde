//based on this site https://gist.github.com/phoemur/151ca1999a76478ed6d74cbbb5d5e1c9
Complex[] ditifft2(Complex[] x){//https://software.intel.com/content/www/us/en/develop/articles/implementation-of-fast-fourier-transform-for-image-processing-in-directx-10.html?wapkw=(scale)
  int N = x.length;
  if(N == 1){
    return null;
  }else{//based on this site https://github.com/bubnicbf/Fast-Fourier-Transform-using-Cooley-Tukey-algorithm/blob/master/FFT.cpp
    Complex[] even = new Complex[N/2];
    Complex[] odd = new Complex[N/2];
    int index = 0;
    for(int i=0; i<N; i+=2)even[index++] = x[i];
    index = 0;
    for(int i=1; i<N; i+=2)odd[index++] = x[i];
    
    ditifft2(even);//update even
    ditifft2(odd);//update odd

    for(int k = 0; k < N/2; k++){
      Complex t = exp(c(TWO_PI*k/N)).mult(odd[k]);
      x[k] = even[k].add(t);
      x[k+N/2] = even[k].sub(t);
    }
  }
  Complex[] res = new Complex[N];
  for(int i=0; i<N; i++)res[i] = x[i];//.div(N);
  return res;
}

Complex[] ditfft2(Complex[] x){//based on this site https://en.wikipedia.org/wiki/Cooley%E2%80%93Tukey_FFT_algorithm
  int N = x.length;
  if(N == 1){
    return null;
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
  return x;
}//result is updated x
