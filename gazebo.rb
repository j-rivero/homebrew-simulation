class Gazebo < Formula
  homepage 'http://gazebosim.org'
  url 'http://gazebosim.org/distributions/gazebo/releases/gazebo-1.9.7.tar.bz2'
  sha256 '27f3f81d3b11f997e8879e660445e49e81f8d15909ef7352b166c5050c61573a'
  head 'https://bitbucket.org/osrf/gazebo', :branch => 'gazebo_1.9', :using => :hg

  depends_on 'cmake'  => :build
  depends_on 'pkg-config' => :build

  depends_on 'boost'
  depends_on 'doxygen'
  depends_on 'freeimage'
  depends_on 'libtar'
  depends_on 'ogre'
  depends_on 'osrf/simulation/protobuf'
  depends_on 'protobuf-c'
  depends_on 'qt'
  depends_on 'sdformat'
  depends_on 'tbb'
  depends_on 'tinyxml'

  depends_on 'bullet' => [:optional, 'shared', 'double-precision']
  depends_on 'ffmpeg' => :optional
  depends_on 'gts' => :optional
  depends_on 'player' => :optional
  depends_on 'simbody' => :optional

  patch do
    # Fix build when homebrew python is installed
    url 'https://gist.githubusercontent.com/scpeters/9199370/raw/afe595587e38737c537124a3652db99de026c272/brew_python_fix.patch'
    sha256 'c4774f64c490fa03236564312bd24a8630963762e25d98d072e747f0412df18e'
  end

  patch do
    # Fix build with protobuf 2.6 (gazebo #1289)
    url 'https://bitbucket.org/osrf/gazebo/commits/4bb4390655af316b582f8e0fea23438426b4e681/raw/'
    sha256 '70d39a547aa27a5357ddf0859d41515c945730ca1cef770be3c0cff2e29340d2'
  end

  patch do
    # Fix build with boost 1.57 (gazebo #1399)
    url 'https://bitbucket.org/osrf/gazebo/commits/39f8398003ada7381dc03096f666627e84c738eb/raw/'
    sha256 '6d38b6f01491f0419d70d72c067a69b75dfc3ac4520b4ceaeb7f0da9436b4a37'
  end

  def install
    ENV.m64

    cmake_args = std_cmake_args.select { |arg| arg.match(/CMAKE_BUILD_TYPE/).nil? }
    cmake_args << "-DCMAKE_BUILD_TYPE=Release"
    cmake_args << "-DENABLE_TESTS_COMPILATION:BOOL=False"
    cmake_args << "-DFORCE_GRAPHIC_TESTS_COMPILATION:BOOL=True"

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make install"
    end
  end
end
