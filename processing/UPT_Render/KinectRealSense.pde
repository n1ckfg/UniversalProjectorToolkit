import ch.bildspur.realsense.*;
import ch.bildspur.realsense.type.*;
import org.intel.rs.frame.DepthFrame;
import org.intel.rs.frame.Points;
import org.intel.rs.processing.PointCloud;
import org.intel.rs.types.Vertex;

class KinectRealSense {
  
  PApplet parent;
  RealSenseCamera device;
  int vertCount = 0;

  PointCloud pointCloud;
  DepthFrame depthFrame;
  Points points;
  Vertex[] vertices;
  
  boolean isOffline = false;
  PImage depthImg, contourImg;

  KinectRealSense(PApplet _parent) {
    parent = _parent;
    device = new RealSenseCamera(parent);
    
    //device.setMirror(false);
    device.enableDepthStream();
    // https://intelrealsense.github.io/librealsense/doxygen/classrs2_1_1colorizer.html
    // a colorizer setting is required to display depth images:
    // 0 - Jet,  1 - Classic, 2 - WhiteToBlack, 3 - BlackToWhite, 4 - Bio, 5 - Cold, 6 - Warm, 7 - Quantized, 8 - Pattern, 9 - Hue
    device.enableColorizer(ColorScheme.WhiteToBlack); 
    //device.enableIRStream();
    //device.enableUser();
    device.enableColorStream();
    //device.alternativeViewPointDepthToImage();
    device.enableAlign();
    device.start();

    pointCloud = new PointCloud();
    vertCount = depthWidth() * depthHeight();
    vertices = new Vertex[vertCount];
}

  void enableDepth() {
    device.enableDepthStream();
  }

  void enableUser() {
    //device.enableUser();
  }
  
  void alternativeViewPointDepthToImage() {
    device.enableAlign();
  }
  
  int depthWidth() {
    return device.getDepthImage().width;
  }
  
  int depthHeight() {
    return device.getDepthImage().height;  
  }
  
  void update() {
    device.readFrames();
  }
  
  PImage rgbImage() {
    return device.getColorImage();
  }
  
  PImage depthImage() {
    return device.getDepthImage();
  }
  
  PImage userImage() {
    return device.getDepthImage(); //getUserImage();
  }
  
  PImage irImage() {
    return device.getIRImage();
  }
  
  PVector[] depthMapRealWorld() {
    PVector[] returns = new PVector[vertCount];
    
    depthFrame = device.getFrames().getDepthFrame();
    points = pointCloud.calculate(depthFrame);
    vertices = points.getVertices();
    points.release();
    
    for (int i=0; i<returns.length; i++) {
      Vertex v = vertices[i];
      // all axes in OpenNI are flipped vs. RS, and scale is mm instead of m.
      returns[i] = new PVector(-v.getX(), -v.getY(), -v.getZ()).mult(1000);
    }
    
    return returns;
  }
  
  int[] depthMap() {
    short[][] data = device.getDepthData();
    int[] returns = new int[data.length * data[0].length];
    int index = 0;
    for (int y = 0; y < data.length; y++) {
      for (int x = 0; x < data[y].length; x++) {
        returns[index] = data[y][x];
        index++;
      }
    }
    return returns;
  }
  
  int[] getRawDepth() {
    return depthMap();
  }
  
  // dummy update methods for offline 
  void update(String[] _depthText, PImage _depthImg, PImage _contourImg) { }
  void update(String[] _depthText, PImage _depthImg, float _threshold) { }
  void update(float _threshold) { }
  
}
