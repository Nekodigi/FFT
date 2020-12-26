//Gaussian Blur Kernel
Complex[][] gaussK(int N, float size){//gaussian blur kernel
  Complex[] temp = new Complex[N];
  Complex[][] result = new Complex[N][N];
  float sum = 0;
  for(int i=0; i<N; i++){
    float t = map(i, 0, N-1, -size, size);
    temp[i] = r(exp(-t*t));
    sum += temp[i].x;
  }
  for(int i=0; i<N; i++){
    temp[i].x /= sum;
  }
  
  for(int i=0; i<N; i++){
    for(int j=0; j<N; j++){
      result[i][j] = temp[i].mult(temp[j]);
    }
  }
  return result;
}

Complex[][] mult(Complex[][] a, Complex[][] b){
  Complex[][] result = new Complex[a.length][a[0].length];
  for(int i = 0; i<256; i++){
    for(int j = 0; j<256; j++){
      result[i][j] = a[i][j].mult(b[i][j]);
    }
  }
  return result;
}

Complex[][] FFT_Shift(Complex[][] x){
  int N1 = x.length;
  int N2 = x[0].length;
  Complex[][] res = new Complex[N1][N2];
  Complex[][] res2 = new Complex[N1][N2];
  
  for(int i=0; i<N1/2; i++){
    res[i] = x[i+N1/2];
    res[i+N1/2] = x[i];
  }

  x = res;
  for(int i=0; i<N1; i++){
    for(int j=0; j<N2/2; j++){
      res2[i][j] = res[i][j+N2/2];
      res2[i][j+N2/2] = res[i][j];
    }
  }
  
  return res2;
}
