//class KinectWrapper extends KinectSoni {  
//class KinectWrapper extends KinectRealSense {  
class KinectWrapper extends KinectOffline {  
 
  PVector[] depthMap;

  KinectWrapper(PApplet _parent) {
    super(_parent);
  }

  // override functions below used to generate depthMapRealWorld point cloud
  PVector[] depthMapRealWorld_Alt() {
    int[] depth = getRawDepth();
    int skip = 1;
    for (int y = 0; y < depthHeight(); y+=skip) {
      for (int x = 0; x < depthWidth(); x+=skip) {
          int offset = x + y * depthWidth();
          //calculate the x, y, z camera position based on the depth information
          PVector point = depthToPointCloudPos(x, y, depth[offset]);
          depthMap[depthWidth() * y + x] = point;
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


// Kinect v2
static class CameraParams {
  static float cx = 254.878f;
  static float cy = 205.395f;
  static float fx = 365.456f;
  static float fy = 365.456f;
  static float k1 = 0.0905474;
  static float k2 = -0.26819;
  static float k3 = 0.0950862;
  static float p1 = 0.0;
  static float p2 = 0.0;
}

/*
// RealSense 435
// https://spectrum.chat/openvslam/beginner/how-to-save-depth-data-and-how-to-write-camera-config~9b02e2b6-ef9e-4031-a3bf-8b13d49a1b6e
static class CameraParams {
  static float cx = (float) 323.1676940917969;
  static float cy = (float) 240.14817810058594;
  static float fx = (float) 609.4935302734375;
  static float fy = (float) 609.4905395507812;
  static float k1 = 0.0;
  static float k2 = 0.0;
  static float k3 = 0.0;
  static float p1 = 0.0;
  static float p2 = 0.0;
}
*/
