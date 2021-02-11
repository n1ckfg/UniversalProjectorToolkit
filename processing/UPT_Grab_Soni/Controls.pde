void keyPressed() {
  if (key == ' ') {
    int timestamp = millis();
    
    // depth map
    depthMap = kinect.depthMapRealWorld();
    String[] depthText = new String[depthMap.length];
    for (int i=0; i<depthMap.length; i++) {
      PVector p = depthMap[i];
      depthText[i] = p.x + ", " + p.y + ", " + p.z;
    }
    saveStrings("render/depth_map_" + timestamp + ".txt", depthText);
    
    // images
    depthImage.save("render/depth_image.png");
    userImage.save("render/user_image.png");
  }
}
