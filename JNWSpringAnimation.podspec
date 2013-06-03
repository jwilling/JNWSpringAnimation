Pod::Spec.new do |s|
  s.name         = "JNWSpringAnimation"
  s.version      = "0.1"
  s.summary      = "JNWSpringAnimation is a subclass of CAKeyframeAnimation that adds support for creating damped harmonic animations."
  s.homepage     = "https://github.com/jwilling/JNWSpringAnimation"
  s.license      = 'MIT'
  s.author       = { "Jonathan Willing" => "jwilling@me.com" }
  s.source       = { :git => "https://github.com/jwilling/JNWSpringAnimation.git", :tag => "0.1" }
  s.platform     = :ios, '5.0'
  s.source_files = '*.{h,m}'
  s.public_header_files = '*.h'
  s.frameworks = 'QuartzCore'
  s.requires_arc = true
end
