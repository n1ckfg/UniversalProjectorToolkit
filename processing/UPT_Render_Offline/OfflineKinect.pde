class OfflineKinect {
  
  int dW, dH;
  PImage depthImg, contourImg;
  String[] depthText;
  PVector[] depthMap;
  
  OfflineKinect() {
    //
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
 
  void update(String[] _depthText, PImage _depthImg, PImage _contourImg) {
    depthText = _depthText;
    depthImg = _depthImg;   
    contourImg = _contourImg;
    
    dW = depthImg.width;
    dH = depthImg.height;     
    depthMap = new PVector[depthText.length];
    
    for (int i=0; i<depthMap.length; i++) {
      String[] s = depthText[i].split(",");
      float x = float(s[0]);
      float y = float(s[1]);
      float z = float(s[2]);
      depthMap[i] = new PVector(x, y, z);
    }    
  }

  PVector[] depthMapRealWorld() {
      return depthMap;
  }
  
}
