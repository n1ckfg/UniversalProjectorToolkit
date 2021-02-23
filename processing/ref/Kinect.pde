boolean mirror = false;
boolean align = true;
boolean multithreaded = true;
PImage depthImg, rgbImg;
PVector[] depthMap;
boolean invertDepth = false;
boolean realWorld = false;

// ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

/*
// OPENKINECT
// OS: Mac / SDK: OpenNI / Devices: Kinect v1

import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;

void setupKinect() {
  depthImg = createImage(640, 480, RGB);
  rgbImg = createImage(640, 480, RGB);
  kinect = new Kinect(this);
  kinect.enableMirror(mirror);
  kinect.initDepth();
  kinect.initVideo();
}

void updateKinect() {
  depthImg = kinect.getDepthImage();
  rgbImg = kinect.getVideoImage();
}
*/

// ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
/*
// KINECT4WIN
// OS: Win / SDK: MS 1.8 / Devices: Kinect v1

import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;

Kinect kinect;

void setupKinect() {
  depthImg = createImage(640, 480, RGB);
  rgbImg = createImage(640, 480, RGB);
  kinect = new Kinect(this);
}

void updateKinect() {
  depthImg = kinect.GetDepth();
  rgbImg = kinect.GetImage();
}
*/
// ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

// KINECTPV2
// OS: Win / SDK: MS 2.0 / Devices: Kinect v2

import KinectPV2.*;

KinectPV2 kinect;

void setupKinect() {
  depthImg = createImage(512, 424, RGB);
  rgbImg = createImage(512, 424, RGB);
  
  kinect = new KinectPV2(this);
  kinect.enableDepthImg(true);
  kinect.enableColorImg(true);
  kinect.init();
}

void updateKinect() {
  depthImg = kinect.getDepthImage();
  rgbImg = kinect.getColorImage();
}

// ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

// SIMPLEOPENNI 
// OS: Win, Mac, Linux / SDK: OpenNI, MS 1.8 / Devices: Kinect v1, clones
/*
import SimpleOpenNI.*;

SimpleOpenNI context;

void setupKinect() {
  depthImg = createImage(640, 480, RGB);
  rgbImg = createImage(640, 480, RGB);
  if (multithreaded) {
    context = new SimpleOpenNI(this,SimpleOpenNI.RUN_MODE_MULTI_THREADED);
  } else {
    context = new SimpleOpenNI(this);
  }
  context.setMirror(mirror);
  context.enableDepth();
  context.enableRGB();
  //context.enableIR();
  if (align) {
    context.alternativeViewPointDepthToImage();
    context.setDepthColorSyncEnabled(true);
  }
}

void updateKinect() {
  context.update();
  depthImg = context.depthImage();
  rgbImg = context.rgbImage();
  //rgbImg = context.irImage();
  if (realWorld) depthMap = context.depthMapRealWorld();
}
*/
// ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
