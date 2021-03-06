int moveDirection = 0;
int moveStep = 15;
boolean doTimestamp = false;
boolean toggleDepthPreview = false;
boolean armAddPointPair = false;
void keyPressed() {
  if (keyCode == 33) {
    isSearchingBoard = true;
    armAddPointPair = true;
  } else if (keyCode == 34) {
    moveDirection++;
    if (moveDirection > 3) moveDirection = 0;
  } else if (keyCode == TAB) {
    toggleDepthPreview = !toggleDepthPreview;
  }

  if (key == ' ') {
    dumpDepthInfo();
  }
}

void mousePressed() {
  if (calibrated && testingMode) {
    testPoint = new PVector(constrain(mouseX-30, 0, kinect.depthWidth()-1), constrain(mouseY-120, 0, kinect.depthHeight()-1));
    int idx = kinect.depthWidth() * (int) testPoint.y + (int) testPoint.x;
    
    testPointP = convertKinectToProjector(kinect.depthMap[idx]);
  }
}

void dumpDepthInfo() {
    int timestamp = millis();
    
    PImage depthImage = kinect.depthImage();
    PVector[] depthMap = kinect.depthMapRealWorld();
    String[] depthText = new String[depthMap.length];
    for (int i=0; i<depthMap.length; i++) {
      PVector p = depthMap[i];
      depthText[i] = p.x + ", " + p.y + ", " + p.z;
    }
    
    if (doTimestamp) {
      saveStrings("render/depth_map_" + timestamp + ".txt", depthText);
      depthImage.save("render/depth_image_" + timestamp + ".png");
      //kinect.userImage().save("render/user_image_" + timestamp + ".png");
    } else {
      saveStrings("render/depth_map.txt", depthText);
      depthImage.save(sketchPath("render/depth_image.png"));
      //kinect.userImage().save(sketchPath("render/user_image.png"));
    }
}
