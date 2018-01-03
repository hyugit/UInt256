Pod::Spec.new do |s|
  s.name = 'UInt256'
  s.version = '0.0.4'
  s.license = 'MIT'
  s.summary = 'UInt256 library written in Swift 4'
  s.homepage = 'https://github.com/mryu87/UInt256'
  s.license = { :type => 'MIT' }
  s.authors = { 'mryu87' => '13056774+mryu87@users.noreply.github.com' }
  s.source = { :git => 'https://github.com/mryu87/UInt256.git', :tag => s.version }
  s.frameworks = 'Foundation'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'

  s.source_files = 'Sources/*.swift'
end

