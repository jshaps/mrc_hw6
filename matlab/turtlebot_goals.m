% Init
% Setup ROS with defaults
%rosinit()

% Get a list of available actions to see what servers are available
rosaction list

load('turtlegoals.mat')

set_initialpose(0,0,0);

for i = 1:length(GoalX)
%% Connect to move_base action server
% This initiates the client and prints out some diagnostic information
[client,goalMsg] = rosactionclient('/move_base')
waitForServer(client);

% Is the client connected to the server?
client.IsServerConnected

%% Setup call back functions for the action client
client.ActivationFcn=@(~)disp('Goal active');
client.FeedbackFcn=@(~,msg)fprintf('Feedback: X=%.2f, Y=%.2f, yaw=%.2f, pitch=%.2f, roll=%.2f  \n',msg.BasePosition.Pose.Position.X,...
    msg.BasePosition.Pose.Position.Y,quat2eul([msg.BasePosition.Pose.Orientation.W,...
    msg.BasePosition.Pose.Orientation.X,msg.BasePosition.Pose.Orientation.Y, ...
    msg.BasePosition.Pose.Orientation.Z]));

client.FeedbackFcn=@(~,msg)fprintf('Feedback: X=%.2f\n',msg.BasePosition.Pose.Position.X);
client.ResultFcn=@(~,res)fprintf('Result received: State: <%s>, StatusText: <%s>\n',res.State,res.StatusText);

%% Populate the goal to be sent to the server
% A good way to determine the syntax is to use tab-complete in the command
% window

    
    goalMsg.TargetPose.Header.FrameId = 'map';
    goalMsg.TargetPose.Pose.Position.X = GoalX(i);
    goalMsg.TargetPose.Pose.Position.Y = GoalY(i);
%     yawtgt = pi/2;   % Setting the target heading
%     q = eul2quat([yawtgt, 0,0]);      I don't think we need this bc we
%     have orientation goals in the ts_goal.Data
    goalMsg.TargetPose.Pose.Orientation.W=goal_qW(i);
    goalMsg.TargetPose.Pose.Orientation.X=goal_qX(i);
    goalMsg.TargetPose.Pose.Orientation.Y=goal_qY(i);
    goalMsg.TargetPose.Pose.Orientation.Z=goal_qZ(i);

    resultmsg = sendGoalAndWait(client,goalMsg);
%fprintf('Action completed: State: <%s>, StatusText: <%s>\n',resultmsg.State,resultmsg.StatusText);
    

% If necessary, cancel the action 
    cancelAllGoals(client)
    delete(client) % not sure if we need to delete client every time
end
% 
% %% Shutdown
% rosshutdown()
% delete(client)