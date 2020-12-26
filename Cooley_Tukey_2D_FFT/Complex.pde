Complex c(float y){
  return new Complex(0, y);
}

Complex c(float x, float y){
  return new Complex(x, y);
}

Complex r(float x){
  return new Complex(x, 0);
}

Complex exp(Complex z){//based on this site https://mathworld.wolfram.com/ComplexexExponentiation.html
  return new Complex(cos(z.y), sin(z.y)).mult(exp(z.x));
}

class Complex{//Complexex number
  float x, y;
  Complex(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  String toString(){
    return "("+str(x)+","+str(y)+")";
  }
  
  Complex powt(float value){//return this^value
    float angle = atan2(y, x);
    float mag = sqrt(x*x + y*y);
    float rangle = angle*value;
    float rmag = pow(mag, value);
    return new Complex(cos(rangle)*rmag, sin(rangle)*rmag);
  }
  
  float abs(){
    return sqrt(x*x + y*y);
  }
  
  //based on this site https://mathworld.wolfram.com/ComplexMultiplication.html
  Complex mult(Complex z){
    return new Complex(x*z.x - y*z.y, x*z.y + y*z.x);
  }
  
  Complex mult(float val){
    return new Complex(x*val, y*val);
  }
  
  Complex div(float val){ 
    return new Complex(x/val, y/val);
  }
  
  Complex add(Complex target){
    return new Complex(x+target.x, y+target.y);
  }
  
  Complex add(float target){
    return new Complex(x+target, y);
  }
  
  Complex sub(Complex target){
    return new Complex(x-target.x, y-target.y);
  }
  
  Complex sub(float target){
    return new Complex(x-target, y);
  }
}
