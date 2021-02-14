//==========================================================
// set resolution of your projector image/second monitor
// and name of your calibration file-to-be
int pWidth = 1920;//1280;
int pHeight = 1080;//720; 
String calibFilename = "calibration.txt";

//==========================================================
//==========================================================

import javax.swing.JFrame;
import gab.opencv.*;
import controlP5.*;
import Jama.*;

KinectWrapper kinect;
OpenCV opencv;
ChessboardFrame frameBoard;
ChessboardApplet ca;
PImage src;
ArrayList<PVector> foundPoints = new ArrayList<PVector>();
ArrayList<PVector> projPoints = new ArrayList<PVector>();
ArrayList<PVector> ptsK, ptsP;
PVector testPoint, testPointP;
boolean isSearchingBoard = false;
boolean calibrated = false;
boolean testingMode = false;
int cx, cy, cwidth;

void setup() {
  surface.setSize(1200, 768);
  
  textFont(createFont("Courier", 24));
  frameBoard = new ChessboardFrame();

  // set up kinect 
  kinect = new KinectWrapper(this);
  opencv = new OpenCV(this, kinect.depthWidth(), kinect.depthHeight());

  // matching pairs
  ptsK = new ArrayList<PVector>();
  ptsP = new ArrayList<PVector>();
  testPoint = new PVector();
  testPointP = new PVector();
  setupGui();
}

void draw() {
  // draw chessboard onto scene
  if (moveVertical) {
    cy += moveStep;
    if (cy > pHeight) cy = 0;
  } else {
    cx += moveStep;
    if (cx > pWidth) cx = 0;
  }
  cx = constrain(cx, 0, pWidth);
  cy = constrain(cy, 0, pHeight);
  projPoints = drawChessboard(cx, cy, cwidth);

  // update kinect and look for chessboard
  kinect.update();
  //kinect.depthMap = kinect.depthMapRealWorld();
  opencv.loadImage(kinect.rgbImage());
  //opencv.loadImage(kinect.irImage());
  opencv.gray();

  if (isSearchingBoard) foundPoints = opencv.findChessboardCorners(4, 3);
  if (foundPoints.size() > 0) {
    kinect.depthMap = kinect.depthMapRealWorld();    
  }

  drawGui();

  surface.setTitle("" + frameRate);
}

void drawGui() {
  background(0, 100, 0);

  // draw the RGB image
  pushMatrix();
  translate(30, 120);
  textSize(22);
  fill(255);
  image(kinect.rgbImage(), 0, 0);
  
  // draw chessboard corners, if found
  if (isSearchingBoard) {
    int numFoundPoints = 0;
    for (PVector p : foundPoints) {
      if (getDepthMapAt((int)p.x, (int)p.y).z > 0) {
        fill(0, 255, 0);
        numFoundPoints += 1;
      } else {
        fill(255, 0, 0);
      }
      ellipse(p.x, p.y, 5, 5);
    }
    if (numFoundPoints == 12) {
      guiAdd.show();
    } else {
      guiAdd.hide();
    }
  } else {
    guiAdd.hide();
  }
  if (calibrated && testingMode) {
    fill(255, 0, 0);
    ellipse(testPoint.x, testPoint.y, 10, 10);
  }
  popMatrix();

  // draw GUI
  pushMatrix();
  pushStyle();
  translate(kinect.depthWidth()+70, 40); // this is black box
  fill(0);
  rect(0, 0, 450, 680); // blackbox size
  fill(255);
  text(ptsP.size()+" pairs", 26, guiPos.y+525);
  popStyle();
  popMatrix();
}

ArrayList<PVector> drawChessboard(int x0, int y0, int cwidth) {
  ArrayList<PVector> projPoints = new ArrayList<PVector>();
  ca.redraw();
  return projPoints;
}


void addPointPair() {
  if (projPoints.size() == foundPoints.size()) {
    println(getDepthMapAt((int) foundPoints.get(1).x, (int) foundPoints.get(1).y));
    for (int i=0; i<projPoints.size(); i++) {
      ptsP.add( projPoints.get(i) );
      ptsK.add( getDepthMapAt((int) foundPoints.get(i).x, (int) foundPoints.get(i).y) );
    }
  }
  guiCalibrate.show();
  guiClear.show();
}

PVector getDepthMapAt(int x, int y) {
  PVector dm = kinect.depthMap[kinect.depthWidth() * y + x];
  
  return new PVector(dm.x, dm.y, dm.z);
}

void clearPoints() {
  ptsP.clear();
  ptsK.clear();
  guiSave.hide();
}

void saveC() {
  saveCalibration(calibFilename); 
}

void loadC() {
  println("load");
  loadCalibration(calibFilename);
  guiTesting.addItem("Testing Mode", 1);
}
