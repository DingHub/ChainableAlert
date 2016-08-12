Pod::Spec.new do |s|

  s.name         = "ChainableAlert"
  s.version      = "0.1"
  s.license      = "Copyright (c) 2016 Ding"
  s.summary      = "Chainable use of Alert."
  s.homepage     = "https://github.com/DingHub/ChainableAlert"
  s.license      = "MIT"
  s.author       = { "DingHub" => "love-nankai@163.com" }
  s.source       = { :git => "https://github.com/DingHub/ChainableAlert.git", :tag => "0.1" }
  s.source_files  = "Source/*.{Swift}"
  s.platform     = :ios
  s.platform     = :ios, "7.0"
  s.requires_arc = true

end
