boolean moveVertical = false;
int moveStep = 5;

void keyPressed() {
  if (keyCode == 33) {
    addPointPair();
  } else if (keyCode == 34) {
    moveVertical = !moveVertical;
  }
}

void mousePressed() {
  if (calibrated && testingMode) {
    testPoint = new PVector(constrain(mouseX-30, 0, kinect.depthWidth()-1), constrain(mouseY-120, 0, kinect.depthHeight()-1));
    int idx = kinect.depthWidth() * (int) testPoint.y + (int) testPoint.x;
    
    testPointP = convertKinectToProjector(depthMap[idx]);
  }
}
