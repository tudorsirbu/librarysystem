class SettingsController < ApplicationController
  before_action :load_settings
  before_action :settings_params, except: [:index]
  after_action :save_settings

  def index
    puts @settings.to_s + "!!!!!!!!"
  end

  def save
    redirect_to settings_path
  end

  private

  def settings_params
    params.require('/settings/save').permit(:location)
  end

  def load_settings
    @settings = cookies[:location]
  end

  def save_settings
    puts params.to_s
    if params.has_key?'/settings/save'
      cookies[:location] = params['/settings/save'][:location]
    end
    puts cookies[:location].to_s
  end

end
