void keyPressed() {
  if (keyCode == 33 || keyCode == 34) {
    //
  }
}

void mousePressed() {
  if (calibrated && testingMode) {
    testPoint = new PVector(constrain(mouseX-30, 0, depthWidth-1), constrain(mouseY-120, 0, depthHeight-1));
    int idx = depthWidth * (int) testPoint.y + (int) testPoint.x;
    
    testPointP = convertKinectToProjector(depthMap[idx]);
  }
}
