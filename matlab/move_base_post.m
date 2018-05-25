% Read the image
ifile = '~/map.pgm';   % Image file name
I=imread(ifile);
 

% set bag file path% Create a bag file object with the file name
bag = rosbag('~/catkin_ws/src/mrc_hw6/matlab/turtlebag.bag');
   
% Select by topic
amcl_select = select(bag,'Topic','/amcl_pose');% Get just the topic we are interested in

odom_select = select(bag,'Topic','/odom');
   
% Create a time series object based on the fields of the turtlesim/Pose
% message we are interested in
ts_odom = timeseries(odom_select,'Pose.Pose.Position.X','Pose.Pose.Position.Y',...
    'Twist.Twist.Linear.X','Twist.Twist.Angular.Z',...
    'Pose.Pose.Orientation.W','Pose.Pose.Orientation.X',...
    'Pose.Pose.Orientation.Y','Pose.Pose.Orientation.Z');

% Create time series object
ts_amcl = timeseries(amcl_select,'Pose.Pose.Position.X','Pose.Pose.Position.Y',...
    'Pose.Pose.Orientation.W','Pose.Pose.Orientation.X',...
    'Pose.Pose.Orientation.Y','Pose.Pose.Orientation.Z');

% Select by topic
goal_select = select(bag,'Topic','/move_base/goal');
 
% Create time series object
ts_goal = timeseries(goal_select,'Goal.TargetPose.Pose.Position.X','Goal.TargetPose.Pose.Position.Y',...
    'Goal.TargetPose.Pose.Orientation.W','Goal.TargetPose.Pose.Orientation.X',...
    'Goal.TargetPose.Pose.Orientation.Y','Goal.TargetPose.Pose.Orientation.Z');

%% Exctract and Plot

GoalX = ts_goal.Data(:,1); GoalY = ts_goal.Data(:,2); %Extract goal pose
BotX = ts_odom.Data(:,1); BotY = ts_odom.Data(:,2); %Extract bot pose
AmclX = ts_amcl.Data(:,1); AmclY = ts_amcl.Data(:,2);

% Set the size scaling
xWorldLimits = [-10 9.2];
yWorldLimits = [-10 9.2];
RI = imref2d(size(I),xWorldLimits,yWorldLimits)
 
% Plot
figure();
clf()
imshow(flipud(I),RI)
set(gca,'YDir','normal')
hold on;
plot(BotX,BotY,'-g',AmclX,AmclY,'.b',GoalX,GoalY,'*r');
legend('BotPose','AMCL Pose','Goals');

