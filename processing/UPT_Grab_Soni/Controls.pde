void keyPressed() {
  if (key == ' ') {
    int timestamp = millis();
    
    // depth map
    depthMap = kinect.depthMapRealWorld();
    ArrayList<String> depthText = new ArrayList<String>();
    for (int i=0; i<depthMap.length; i++) {
      PVector p = depthMap[i];
      depthText.add(p.x + ", " + p.y + ", " + p.z);
    }
    String[] depthTextArray = depthText.toArray(new String[depthText.size()]);
    saveStrings("render/depth_map_" + timestamp + ".txt", depthTextArray);
    
    // images
    depthImage.save("render/depth_image.png");
    userImage.save("render/user_image.png");
  }
}
