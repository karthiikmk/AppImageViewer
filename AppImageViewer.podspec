
Pod::Spec.new do |s|
  s.name             = 'AppImageViewer'
  s.version          = '1.0.29'
  s.swift_version    = '4.2'
  s.summary          = 'A great framework to viewer you images gracefully.'
  s.description      = "Image viewing will be great with this. really fun. all you need plug and and play with your waves. yay yay. simple isn't it !!"

  s.homepage         = 'https://github.com/karthikAdaptavant/AppImageViewer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'karthikAdaptavant' => 'karthik.samy@a-cti.com' }
  s.source           = { :git => 'https://github.com/karthikAdaptavant/AppImageViewer.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.source_files = 'AppImageViewer/Classes/**/*'
  
   s.resource_bundles = {
     'AppImageViewer' => ['AppImageViewer/Assets/*.png']
   }

    s.resource_bundles = {
    'AppImageViewer' => ['AppImageViewer/Assets/**/*.{xcassets}']
    }

  s.frameworks = 'UIKit'

end

#To make build. cd to the framework path (not example), run fastlane
#To Make Build, use fulliosdevelopers bitrise account.
#if any push happend in deploy branch, bitrise trigger will be executed
