import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
float tilt;

void setup(){
  kinect = new Kinect(this);
  tilt = kinect.getTilt();
  size(1000,1000);
}

void draw(){
  
}

void keyPressed(){
  //Set tilt of Kinect Camera using the Up and Down Arrow Keys
  if (key == CODED){
   if (keyCode == UP){
     tilt++; 
   } else if(keyCode == DOWN){
     tilt--; 
   }
   tilt = constrain(tilt, 0, 30);
   kinect.setTilt(tilt);
  }  
}


