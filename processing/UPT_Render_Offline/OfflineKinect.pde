class OfflineKinect {
  
  int dW, dH;
  PImage depthImg, contourImg;
  PVector[] depthMap;
  
  OfflineKinect(PImage _depthImg, PImage _contourImg) {
    dW = _depthImg.width;
    dH = _depthImg.height;     
    depthMap = new PVector[_depthImg.pixels.length];
    
    update(_depthImg, _contourImg);
  }
  
  int depthWidth() {
    return dW;
  }
  
  int depthHeight() {
    return dH;
  }
  
  PImage userImage() {
    return contourImg;
  }
 
  void update(PImage _depthImg, PImage _contourImg) {
    depthImg = _depthImg;   
    contourImg = _contourImg;
    
    // TODO calculate real world depth map    
  }

  PVector[] depthMapRealWorld() {
    int[] depth = kinect.getRawDepth();
    int skip = 1;
    for (int y = 0; y < kinect.depthHeight(); y+=skip) {
      for (int x = 0; x < kinect.depthWidth(); x+=skip) {
          int offset = x + y * kinect.depthWidth();
          //calculate the x, y, z camera position based on the depth information
          PVector point = depthToPointCloudPos(x, y, depth[offset]);
          depthMap[kinect.depthWidth() * y + x] = point;
        }
      }
      return depthMap;
  }
  
  //calculte the xyz camera position based on the depth data
  PVector depthToPointCloudPos(int x, int y, float depthValue) {
    PVector point = new PVector();
    point.z = (depthValue);// / (1.0f); // Convert from mm to meters
    point.x = ((x - CameraParams.cx) * point.z / CameraParams.fx);
    point.y = ((y - CameraParams.cy) * point.z / CameraParams.fy);
    return point;
  }

}
