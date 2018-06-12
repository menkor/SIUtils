#
# Be sure to run `pod lib lint SIUtils.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'SIUtils'
    s.version          = '0.1.8'
    s.summary          = 'SIUtils.'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = <<-DESC
    SIUtils of Super Id.
    DESC
    
    s.homepage         = 'http://superid.cn:81/iOS/SIUtils'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'ungacy' => 'yetao@superid.cn' }
    s.source           = { :git => 'git@git.superid.cn:iOS/SIUtils.git', :tag => s.version.to_s }
    s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
    s.ios.deployment_target = '9.0'
    s.public_header_files = 'SIUtils/Classes/**/*.h'
    s.source_files = 'SIUtils/Classes/**/*'
    s.dependency 'YYKit'
    s.dependency 'SAMKeychain'
    s.dependency 'YCEasyTool'
    s.dependency 'AFNetworking'
end
