class SettingsController < ApplicationController
  before_action :load_settings
  before_action :settings_params, except: [:index]
  after_action :save_settings

  def index
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
    if params.has_key?'/settings/save'
      location = params['/settings/save'][:location]
      cookies[:location] = location
    end
  end

end
