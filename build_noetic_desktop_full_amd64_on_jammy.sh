#!/bin/bash

rm -rf ~/ros_catkin_ws

ROS_DISTRO=noetic

sudo apt-get install python3-rosdep python3-rosinstall-generator python3-vcstools python3-vcstool build-essential
sudo rosdep init
rosdep update

mkdir ~/ros_catkin_ws
cd ~/ros_catkin_ws
rosinstall_generator desktop_full --rosdistro noetic --deps --tar > noetic-desktop-full.rosinstall
mkdir ./src
vcs import --input noetic-desktop-full.rosinstall ./src

sudo apt-get install libfltk1.3-dev

#hddtemp disable patch
sed -i -e s/"<run_depend>hddtemp<\/run_depend>"/"<\!-- <run_depend>hddtemp<\/run_depend> -->"/g ./src/diagnostics/diagnostic_common_diagnostics/package.xml

rosdep install --from-paths ./src --ignore-packages-from-source --rosdistro noetic -y

sed -i -e s/"COMPILER_SUPPORTS_CXX11"/"COMPILER_SUPPORTS_CXX17"/g ./src/geometry/tf/CMakeLists.txt
sed -i -e s/"c++11"/"c++17"/g ./src/geometry/tf/CMakeLists.txt
sed -i -e s/"CMAKE_CXX_STANDARD 14"/"CMAKE_CXX_STANDARD 17"/g ./src/kdl_parser/kdl_parser/CMakeLists.txt
sed -i -e s/"CMAKE_CXX_STANDARD 11"/"CMAKE_CXX_STANDARD 17"/g ./src/laser_geometry/CMakeLists.txt
sed -i -e s/"c++11"/"c++17"/g ./src/resource_retriever/CMakeLists.txt
sed -i -e s/"COMPILER_SUPPORTS_CXX11"/"COMPILER_SUPPORTS_CXX17"/g ./src/robot_state_publisher/CMakeLists.txt
sed -i -e s/"c++11"/"c++17"/g ./src/robot_state_publisher/CMakeLists.txt
sed -i -e s/"c++11"/"c++17"/g ./src/rqt_image_view/CMakeLists.txt
sed -i -e s/"CMAKE_CXX_STANDARD 14"/"CMAKE_CXX_STANDARD 17"/g ./src/urdf/urdf/CMakeLists.txt

sed -i -e s/"CMAKE_CXX_STANDARD 14"/"CMAKE_CXX_STANDARD 17"/g ./src/perception_pcl/pcl_ros/CMakeLists.txt
sed -i -e s/"c++14"/"c++17"/g ./src/perception_pcl/pcl_ros/CMakeLists.txt
sed -i -e s/"CMAKE_CXX_STANDARD 11"/"CMAKE_CXX_STANDARD 17"/g ./src/laser_filters/CMakeLists.txt 


rm -rf ./src/rosconsole
cd src
git clone https://github.com/tatsuyai713/rosconsole
cd ..

./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release
