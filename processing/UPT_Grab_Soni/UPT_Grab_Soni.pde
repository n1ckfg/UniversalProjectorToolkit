import SimpleOpenNI.*;

SimpleOpenNI kinect;

void setup() {
  size(1280, 480, P2D);

  // set up kinect 
  kinect = new SimpleOpenNI(this, SimpleOpenNI.RUN_MODE_MULTI_THREADED);
  kinect.setMirror(false);
  kinect.enableDepth();
  //kinect.kinect.enableIR();
  //kinect.enableRGB();
  kinect.enableUser();
  kinect.alternativeViewPointDepthToImage();
}

void draw() {
  kinect.update();
  
  image(kinect.depthImage(), 0, 0);
  image(kinect.userImage(), 640, 0);
}
