Pod::Spec.new do |s|
  s.name = 'UInt256'
  s.version = '0.2.2'
  s.license = 'MIT'
  s.summary = 'UInt256 library written in Swift 4'
  s.homepage = 'https://github.com/hyugit/UInt256'
  s.license = { :type => 'MIT' }
  s.authors = { 'hyugit' => '13056774+hyugit@users.noreply.github.com' }
  s.source = { :git => 'https://github.com/hyugit/UInt256.git', :tag => s.version }
  s.frameworks = 'Foundation'
  s.swift_versions = '5.0.1'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'

  s.source_files = 'Sources/*.swift'
end

