cmake_minimum_required(VERSION 2.8)
project( Algorithms )

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

find_package( OpenCV REQUIRED )
include_directories( ${OpenCV_INCLUDE_DIRS} )

add_executable( RunAlgorithms RunAlgorithms.cpp )
target_link_libraries( RunAlgorithms ${OpenCV_LIBS} )

add_executable( RunAlgorithms2 RunAlgorithms2.cpp )
target_link_libraries( RunAlgorithms2 ${OpenCV_LIBS} )



