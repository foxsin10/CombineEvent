Pod::Spec.new do |s|

    s.name         = "CombineEvent"
    s.version      = "0.5.1"
    s.summary      = "convenience wrapper api when using combine"
  
    s.description  = <<-DESC
                     This repo collects some convenience wrapper api when using combine.
                     
                     DESC
  
    s.homepage     = "https://github.com/foxsin10/CombineEvent"
  
    s.license      = { :type => "MIT", :file => "LICENSE" }
  
    s.authors            = { "foxsion10" => "yzjcnn@gmail.com" }
    s.social_media_url   = "https://github.com/foxsin10"
  
    s.swift_versions = ['5.3']
  
    s.ios.deployment_target = "13.0"
  
    s.source       = { :git => "https://github.com/foxsin10/CombineEvent.git", :tag => s.version }
    s.source_files  = ["Sources/**/*.swift"]
  
    s.requires_arc = true
  end
  