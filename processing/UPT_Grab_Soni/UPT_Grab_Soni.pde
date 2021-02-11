import SimpleOpenNI.*;

SimpleOpenNI kinect;
PVector[] depthMap;
PImage depthImage, userImage;

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
  
  depthImage = kinect.depthImage();
  userImage = kinect.userImage();
  
  if (depthImage != null) image(depthImage, 0, 0);
  if (userImage != null) image(userImage, 640, 0);
}
