boolean doTimestamp = false;

void keyPressed() {
  if (key == ' ') {
    dumpDepthInfo();
  }
}

void dumpDepthInfo() {
    int timestamp = millis();
    
    PVector[] depthMap = kinect.depthMapRealWorld();
    String[] depthText = new String[depthMap.length];
    for (int i=0; i<depthMap.length; i++) {
      PVector p = depthMap[i];
      depthText[i] = p.x + ", " + p.y + ", " + p.z;
    }
    
    if (doTimestamp) {
      saveStrings("render/depth_map_" + timestamp + ".txt", depthText);
      kinect.depthImage().save("render/depth_image_" + timestamp + ".png");
      //kinect.userImage().save("render/user_image_" + timestamp + ".png");
    } else {
      saveStrings("render/depth_map.txt", depthText);
      kinect.depthImage().save("render/depth_image.png");
      //kinect.userImage().save("render/user_image.png");
    }
}
