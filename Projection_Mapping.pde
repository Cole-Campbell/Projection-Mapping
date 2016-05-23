import org.openkinect.freenect.*;
import org.openkinect.processing.*;

// The kinect stuff is happening in another class
Track track;
Kinect kinect;

//Counter for the number of times a red square is found
int counter = 0;
// Tilt of Kinect, which is controlled by keypress ^v
float tilt;
PImage img;
PImage eye;
PImage portrait;

// PNG Sequence arrays which will hold the images for animation
PImage[] evil = new PImage[38];
PImage[] blackEye = new PImage[58];
PImage[] slide = new PImage[85];

// These variables determine whether the animations will run, which one and make sure
// They start from frame 0.
int count = 0;
boolean timer = false;
int ranHit;
int currentFrame = 0;

void setup() {

  //Development Size - size(1400, 1500);
  size(733, 1000);
  kinect = new Kinect(this);
  track = new Track();
  tilt = kinect.getTilt();

  // Images being declared for later use within the sketch
  eye = loadImage("eye.png");
  portrait = loadImage("portrait.png");

  // Series of For statements which declare run through and create the name of the
  // Images that will be then stored into the appropriate array
  for (int i = 0; i<=37; i++) {
    String name = "Flash_" + nf(i, 3)+".png";
    evil[i] = loadImage(name);
  }

  for (int i = 0; i<=57; i++) {
    String name = "BlackEyes_" + nf(i, 3)+".png";
    blackEye[i] = loadImage(name);
  }

  for (int i = 0; i<=84; i++) {
    String name = "Slide_" + nf(i, 3)+".png";
    slide[i] = loadImage(name);
  }
}

void draw() {
  // Count adds every frame, to act as a timer for when the animations may run
  count++;
  background(185, 150, 143);

  // Run the tracking analysis
  track.track();
  // Show the image
  track.display();

  //Raw image location
  PVector v1 = track.getPos();
  // Po is the left eye, Pe is the right eye, Pa is the eye's Y position
  float po = map(v1.x, 0, width, 330, 375);
  float pe = map(v1.x, 0, width, 420, 465);
  float pa = map(v1.y, 0, height, 225, 250);

  noStroke();

  image(eye, po, pa, 20, 20);
  image(eye, pe, pa+5, 20, 20);
  image(portrait, 0, 0);

  // Resetting Counter to 0 every frame so number of pixels which are red aren't added
  counter=0;

  // Runs through the pixel array of the Kinect's DepthMap looking for red pixels
  // When there is a red pixel, the counter is increased by 1
  for (int i = 0; i<track.display.pixels.length; i++) {
    if (track.display.pixels[i] == color(208, 80, 74)) {
      counter++;
    } else {
    }
  }

  // Count timer being checked. If it hits 2000 (2000/50frames = 40 Seconds)
  // Then boolean is equal to true and the RanHit generates either 0, 1, 2
  if (count==500) {
    timer = true;
    ranHit = int(random(3));
  }

  // If statement checking for both timer to be true and the DepthMap counter to equal
  // 30000 red pixels. Once that is then animation will initiate
  if (timer ==true && counter>=30000) {
    int offset = 0;

    // Runs "Evil" animation
    if (ranHit == 0) {
      currentFrame = (currentFrame+1) % 38;
      for (int i = 0; i<=38; i++) {
        image(evil[(currentFrame+offset) % evil.length], 0, 0);

        // If the frame of the Evil animation is equal to 37, the end, then it will
        // Reset count timer to 0, timer to false and currentFrame to 0 so next
        // Animation will start at the 0 frame
        if ((currentFrame+offset) % evil.length == 37) {
          count=0;
          timer = false;
          currentFrame = 0;
        }
      }
    }

    // Runs "Black Eye" animation
    if (ranHit == 1) {
      currentFrame = (currentFrame+1) % 58;
      for (int i = 0; i<=58; i++) {
        image(blackEye[(currentFrame+offset) % blackEye.length], 0, 0);
        if ((currentFrame+offset) % blackEye.length == 57) {
          count=0;
          timer = false;
          currentFrame = 0;
        }
      }
    }

    // Runs the "Slide" animation
    if (ranHit == 2 ) {
      currentFrame = (currentFrame+1) % 85;
      for (int i = 0; i<=149; i++) {
        image(slide[(currentFrame+offset) % slide.length], 0, 0);
        println((currentFrame+offset) % slide.length);
        if ((currentFrame+offset) % slide.length == 84) {
          count=0;
          timer = false;
          currentFrame = 0;
        }
      }
    }
  }
}

void keyPressed() {
  //Set tilt of Kinect Camera using the Up and Down Arrow Keys
  int tr = track.getThreshold();
  if (key == CODED) {
    if (keyCode == UP) {
      tilt++;
    } else if (keyCode == DOWN) {
      tilt--;
    } else if (keyCode == RIGHT) {
      //Adds 10 to threshold 
      tr+=10;
      track.setThreshold(tr);
    } else if (keyCode == LEFT) {
      //Removes 10 to threshold 
      tr-=10;
      track.setThreshold(tr);
    }
    tilt = constrain(tilt, 0, 30);
    kinect.setTilt(tilt);
  }
}