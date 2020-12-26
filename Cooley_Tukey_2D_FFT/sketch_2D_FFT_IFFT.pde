//I can get 2D FFT by doing 1D FFT for each row and column.
void twoD_FFT(Complex[][] x){
  int N1 = x.length;
  int N2 = x[0].length;
  
  ditfft2(x);//x[i] will be apdated
  
  Complex[][] y = new Complex[N2][N1];
  for(int j=0; j<N2; j++)//swap row and column
    for(int i=0; i<N1; i++) y[j][i] = x[i][j]; 
    
  ditfft2(y);
  
  for(int j=0; j<N2; j++)//swap row and column
    for(int i=0; i<N1; i++) x[i][j] = y[j][i]; 
}

Complex[][] twoD_IFFT(Complex[][] x){
  int N1 = x.length;
  int N2 = x[0].length;
  
  ditifft2(x);//x[i] will be apdated
  
  Complex[][] y = new Complex[N2][N1];
  for(int j=0; j<N2; j++)//swap row and column
    for(int i=0; i<N1; i++) y[j][i] = x[i][j].div(N2); 
    
  ditifft2(y);
  for(int j=0; j<N2; j++)//swap row and column
    for(int i=0; i<N1; i++) x[i][j] = y[j][i].div(N1); 
  return x;
}

//FFT, IFFT for each row and update x 
//based on this site https://en.wikipedia.org/wiki/Cooley%E2%80%93Tukey_FFT_algorithm
void ditfft2(Complex[][] x){
  for(int i=0; i<x.length; i++) ditfft2(x[i]);
}

//based on this site https://en.wikipedia.org/wiki/Cooley%E2%80%93Tukey_FFT_algorithm
void ditifft2(Complex[][] x){
  for(int i=0; i<x.length; i++) ditifft2(x[i]);
}
