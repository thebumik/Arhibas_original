class Admin::SettingsController < AdminController
  PVARS = [:background_use, :background_color, :background_image, :background_repeat, :background_y_position, :background_x_position, :sidebar_background]

  def config
    bg_files = Dir.glob("#{RAILS_ROOT}/public/images/custom/*.{jpg,gif,jpeg,png}")
    @bg_collection = bg_files.map{|f| File.basename(f) } || []
    
    @settings ||= settings

    if request.post?
      PVARS.each {|v| Settings.send("#{v.to_s}=", params[v]) }
      redirect_to admin_settings_path
    end
  end

  def reset
    PVARS.each {|v| Settings.send("#{v.to_s}=", Settings.defaults[v]) }
    redirect_to admin_settings_path
  end
end
