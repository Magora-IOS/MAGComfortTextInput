#
# Be sure to run `pod lib lint MAGComfortTextInput.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MAGComfortTextInput'
  s.version          = '0.2.7'
  s.summary          = 'Making an input into UITextFields/UITextViews convinient'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Class for centering of focused UITextFields/UITextViews on free space of screen'

  s.homepage         = 'https://github.com/Magora-IOS/MAGComfortTextInput'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Denis Matveev' => 'matveev@magora-systems.com' }
  s.source           = { :git => 'https://github.com/Magora-IOS/MAGComfortTextInput.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MAGComfortTextInput/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MAGComfortTextInput' => ['MAGComfortTextInput/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
    s.dependency 'MAGMatveevReusable', '~> 0.2.0'

end
