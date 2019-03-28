target 'kashika' do
  use_frameworks!
  
  inhibit_all_warnings!

  pod 'Firebase/Core'
  pod 'Pring'
  

  target 'kashikaTests' do
    inherit! :search_paths

    pod 'Firebase/Core'
    pod 'Pring'
  end

  target 'kashikaUITests' do
    inherit! :search_paths

    pod 'Firebase/Core'
    pod 'Pring'
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        if config.name == "Debug" && defined?(target.product_type) && target.product_type == "com.apple.product-type.framework"
          config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = "YES"
        end
      end
    end
  end
end
