class Flowers {
  
  int x;
  int y;
  int speed = (int)random(5,20);
  float ran, rc;
  int r;
  color c1,c2,stroke;
  
  Flowers (int x,int y){
    this.x=x;
    this.y=y;
    this.r=(int) random(-70,70);
    rc= random(0,3);
    if (rc<1){
       c1=color(#ffb7c5);
       c2=color(#ffeaee); //center circle
       stroke=color(#fdecf0);
    } else if (rc>=1 && rc<2){  //light pink
       c1=color(#feeeed);
       c2=color(#fffef9); //center circle
       stroke=color(#f391a9);
    } else {  
       c1=color(#EEA9B8);
       c2=color(#FFC1C1); //center circle
       stroke=color(#f15b6c);
    }
    if (x>width*3 && x<=width*4){
        this.ran=5;
    } else if (x>width*2 && x<=width*3){
        this.ran=4;
    } else if (x>width && x<=width*2){
       this.ran=3;
    } else {
       this.ran=2;
    }
  }
  
  void show() {
    pushMatrix(); 
      rotate(radians(r));
      strokeWeight(1);
      stroke(stroke);
      fill (c1);
      ellipse(x/ran, y/ran, 50/ran, 50/ran);
      ellipse((x+40)/ran, (y+30)/ran, 50/ran, 50/ran);
      ellipse((x-40)/ran, (y+30)/ran, 50/ran, 50/ran);
      ellipse((x-25)/ran, (y+75)/ran, 50/ran, 50/ran);
      ellipse((x+25)/ran, (y+75)/ran, 50/ran, 50/ran);
      fill(c2);
      ellipse(x/ran, (y+40)/ran, 55/ran, 55/ran); // center
    popMatrix();
    
  }

void move (){
   y= y+speed;
   if (y>height*ran+350){
     y = -100;
   }
   if (x>width*ran+100 || x<0){
     x= (int)random(0,width*4);
     y=-100;
   }
}

}
  
