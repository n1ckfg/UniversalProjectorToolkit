//==========================================================
// set resolution of your projector image/second monitor
// and name of your calibration file-to-be
int pWidth = 1280;
int pHeight = 720; 
String calibFilename = "calibration.txt";

//==========================================================
//==========================================================

import javax.swing.JFrame;
//import SimpleOpenNI.*;
import gab.opencv.*;
import controlP5.*;
import Jama.*;

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
  setupRealSense();
  
  opencv = new OpenCV(this, depthWidth, depthHeight);

  // matching pairs
  ptsK = new ArrayList<PVector>();
  ptsP = new ArrayList<PVector>();
  testPoint = new PVector();
  testPointP = new PVector();
  setupGui();
}

void draw() {
  // draw chessboard onto scene
  projPoints = drawChessboard(cx, cy, cwidth);

  // update kinect and look for chessboard
  kinect.readFrames();
  depthMap = depthMapRealWorld(); //kinect.depthMapRealWorld();
  opencv.loadImage(kinect.getColorImage());
  //opencv.loadImage(kinect.irImage());
  opencv.gray();

  if (isSearchingBoard) foundPoints = opencv.findChessboardCorners(4, 3);
  
  drawGui();
}

void drawGui() {
  background(0, 100, 0);

  // draw the RGB image
  pushMatrix();
  translate(30, 120);
  textSize(22);
  fill(255);
  image(kinect.getColorImage(), 0, 0);
  
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
  translate(depthWidth+70, 40); // this is black box
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
  PVector dm = depthMap[depthWidth * y + x];
  
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
