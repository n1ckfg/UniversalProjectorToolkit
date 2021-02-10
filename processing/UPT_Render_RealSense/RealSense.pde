import ch.bildspur.realsense.*;

import org.intel.rs.frame.DepthFrame;
import org.intel.rs.frame.Points;
import org.intel.rs.processing.PointCloud;
import org.intel.rs.types.Vertex;

RealSenseCamera kinect;
PointCloud pointCloud;
int depthWidth, depthHeight;
PVector[] depthMap;

void setupRealSense() {
  kinect = new RealSenseCamera(this);
  //kinect.setMirror(false);
  kinect.enableDepthStream();
  //kinect.kinect.enableIR();
  kinect.enableColorStream();
  //kinect.alternativeViewPointDepthToImage();
  kinect.enableAlign();
  kinect.start();
  
  depthWidth = kinect.getDepthImage().width;
  depthHeight = kinect.getDepthImage().height;
  depthMap = new PVector[depthWidth*depthHeight];
  
  pointCloud = new PointCloud();
}

PVector[] getRealSensePointCloud() {
  PVector[] returns;
  
  DepthFrame depthFrame = kinect.getFrames().getDepthFrame();
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

// override functions below used to generate depthMapRealWorld point cloud
PVector[] depthMapRealWorld() {
  short[][] depth = kinect.getDepthData(); //kinect.getRawDepth();
  int skip = 1;
  for (int y = 0; y < depthHeight; y+=skip) {
    for (int x = 0; x < depthWidth; x+=skip) {
        //calculate the x, y, z camera position based on the depth information
        PVector point = depthToPointCloudPos(x, y, depth[y][x]);
        depthMap[depthWidth * y + x] = point;
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
