function set_initialpose(x,y,yaw)

yawR = yaw*pi/180;

Cov = [0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.0, 0.0, 0.0, 0.0,...
    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,... 
    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.06853891945200942];

quat = eul2quat([yawR,0,0]); %create quaternion for publishing

[pub,msg] = rospublisher('initialpose','geometry_msgs/PoseWithCovarianceStamped');

msg.Header.FrameId = 'map';
    
msg.Pose.Pose.Position.X = x;
msg.Pose.Pose.Position.Y = y;
msg.Pose.Pose.Position.Z = 0;

msg.Pose.Pose.Orientation.X = quat(2);
msg.Pose.Pose.Orientation.Y = quat(3);
msg.Pose.Pose.Orientation.Z = quat(4);
msg.Pose.Pose.Orientation.W = quat(1);

msg.Pose.Covariance = Cov;

send(pub,msg);