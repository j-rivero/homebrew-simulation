class IgnitionPhysics1 < Formula
  desc "Physics library for robotics applications"
  homepage "https://bitbucket.org/ignitionrobotics/ign-physics"
  url "http://gazebosim.org/distributions/ign-physics/releases/ignition-physics-1.0.0~pre1.tar.bz2"
  version "1.0.0~pre1"
  sha256 "49578ef004342064f5bf6508e9f9e552355ca7c23652c8e907895c9c3c86df93"

  bottle do
    root_url "http://gazebosim.org/distributions/ign-physics/releases"
    sha256 "f7d93c04595bb01de5d6be4ed30bc85c0fd93ba9ef0657a92613c147f3a0ea1f" => :mojave
  end

  depends_on "cmake" => :build

  depends_on "bullet"
  depends_on "dartsim"
  depends_on "ignition-cmake2"
  depends_on "ignition-common3"
  depends_on "ignition-math6"
  depends_on "ignition-plugin1"
  depends_on :macos => :mojave # c++17
  depends_on "pkg-config"
  depends_on "sdformat8"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include "ignition/physics.hh"
      int main()
      {
        ignition::physics::CompositeData data;
        return data.Has<std::string>();
      }
    EOS
    system "pkg-config", "ignition-physics1"
    cflags   = `pkg-config --cflags ignition-physics1`.split(" ")
    ldflags  = `pkg-config --libs ignition-physics1`.split(" ")
    system ENV.cc, "test.cpp",
                   *cflags,
                   *ldflags,
                   "-lc++",
                   "-o", "test"
    system "./test"
  end
end