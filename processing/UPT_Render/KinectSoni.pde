import SimpleOpenNI.*;

class KinectSoni {
  
  PApplet parent;
  SimpleOpenNI device;
  boolean isOffline = false;
  PImage depthImg, contourImg;

  KinectSoni(PApplet _parent) {
    parent = _parent;
    device = new SimpleOpenNI(parent);
    
    device.setMirror(false);
    device.enableDepth();
    //device.enableIR();
    //device.enableUser();
    device.enableRGB();
    device.alternativeViewPointDepthToImage();
  }
  
  void enableDepth() {
    device.enableDepth();
  }

  void enableUser() {
    device.enableUser();
  }
  
  void alternativeViewPointDepthToImage() {
    device.alternativeViewPointDepthToImage();
  }
  
  int depthWidth() {
    return device.depthWidth();
  }
  
  int depthHeight() {
    return device.depthHeight();  
  }
  
  void update() {
    device.update();
  }
  
  PImage rgbImage() {
    return device.rgbImage();
  }
  
  PImage depthImage() {
    return device.depthImage();
  }
  
  PImage userImage() {
    return device.userImage();
  }
  
  PImage irImage() {
    return device.irImage();
  }
  
  PVector[] depthMapRealWorld() {
    return device.depthMapRealWorld();
  }
  
  int[] depthMap() {
    return device.depthMap();
  }
  
  int[] getRawDepth() {
    return depthMap();
  }
 
  // dummy update methods for offline 
  void update(String[] _depthText, PImage _depthImg, PImage _contourImg) { }
  void update(String[] _depthText, PImage _depthImg, float _threshold) { }
  void update(float _threshold) { }
  
}
