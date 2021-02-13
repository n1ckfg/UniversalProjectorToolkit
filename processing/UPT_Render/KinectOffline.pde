class KinectOffline {
  
  PApplet parent;
  int dW, dH;
  PImage depthImg, contourImg;
  PGraphics contourGfx;
  PVector[] depthMap;
  PShader threshold_shader;
  boolean isOffline = true;
  
  KinectOffline(PApplet _parent) {
    parent = _parent;
    threshold_shader = loadShader("threshold_user.glsl");
  }
  
  int depthWidth() {
    return dW;
  }
  
  int depthHeight() {
    return dH;
  }
    
  void update(String[] _depthText, PImage _depthImg, PImage _contourImg) {
    updateDepthMap(_depthText);   
    updateDepthImg(_depthImg);
    updateContourImg(_contourImg);
  }

  void update(String[] _depthText, PImage _depthImg, float _threshold) {
    updateDepthMap(_depthText);   
    updateDepthImg(_depthImg);
    updateContourImg(_threshold);
  }
  
  void update(float _threshold) {
    updateContourImg(_threshold);
  }

  void updateContourImg(float _threshold) {
    threshold_shader.set("tex0", depthImg);
    threshold_shader.set("threshold", _threshold);
    
    contourGfx.beginDraw();
    contourGfx.background(255,0,0);
    contourGfx.filter(threshold_shader);
    contourGfx.endDraw();
    
    contourImg = contourGfx;
  }
  
  void updateContourImg(PImage _contourImg) {
    contourImg = _contourImg;
  }
  
  void updateDepthImg(PImage _depthImg) {
    depthImg = _depthImg;       
    dW = depthImg.width;
    dH = depthImg.height;   
    threshold_shader.set("iResolution", dW, dH, 1.0);
    contourGfx = createGraphics(dW, dH, P2D);
  }
  
  void updateDepthMap(String[] _depthText) {
    depthMap = new PVector[_depthText.length];
    for (int i=0; i<depthMap.length; i++) {
      String[] s = _depthText[i].split(",");
      float x = float(s[0]);
      float y = float(s[1]);
      float z = float(s[2]);
      depthMap[i] = new PVector(x, y, z);
    }
  }

  PVector[] depthMapRealWorld() {
      return depthMap;
  }
  
  PImage userImage() {
    return contourImg;
  }
  
  int[] depthMap() {
    int[] returns = new int[depthMap.length];
    for (int i=0; i<returns.length; i++) {
      returns[i] = int(abs(depthMap[i].z));
    }
    return returns;
  }
  
  int[] getRawDepth() {
    return depthMap();
  }
  
  // ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
  
  void update() {
    //
  }
  
  void enableDepth() {
    //
  }

  void enableUser() {
    //
  }
  
  void alternativeViewPointDepthToImage() {
    //
  }
  
}
