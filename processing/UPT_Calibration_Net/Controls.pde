void keyPressed() {
  if (keyCode == 33 || keyCode == 34) {
    //
  }
}

void mousePressed() {
  if (calibrated && testingMode) {
    testPoint = new PVector(constrain(mouseX-30, 0, host.depth.width-1), constrain(mouseY-120, 0, host.depth.height-1));
    int idx = host.depth.width * (int) testPoint.y + (int) testPoint.x;
    
    testPointP = convertKinectToProjector(depthMap[idx]);
  }
}
