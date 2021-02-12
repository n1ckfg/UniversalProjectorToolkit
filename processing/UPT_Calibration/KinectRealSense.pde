import ch.bildspur.realsense.*;

import org.intel.rs.frame.DepthFrame;
import org.intel.rs.frame.Points;
import org.intel.rs.processing.PointCloud;
import org.intel.rs.types.Vertex;

class KinectRealSense {
  
  PApplet parent;
  RealSenseCamera device;
  PointCloud pointCloud;

  KinectRealSense(PApplet _parent) {
    parent = _parent;
    device = new RealSenseCamera(parent);
    
    //device.setMirror(false);
    device.enableDepthStream();
    //device.enableIR();
    //device.enableUser();
    device.enableColorStream();
    //device.alternativeViewPointDepthToImage();
    device.enableAlign();
    device.start();

    pointCloud = new PointCloud();
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
    PVector[] returns;
    
    DepthFrame depthFrame = device.getFrames().getDepthFrame();
    Points points = pointCloud.calculate(depthFrame);
    Vertex[] vertices = points.getVertices();
    points.release();
    
    returns = new PVector[vertices.length];
    for (int i=0; i<returns.length; i++) {
      Vertex v = vertices[i];
      returns[i] = new PVector(v.getX(), v.getY(), v.getZ());
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
  
}
