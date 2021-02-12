import SimpleOpenNI.*;

class KinectSoni {
  
  PApplet parent;
  SimpleOpenNI device;
  
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
    return device.depthMap();
  }
  
}
