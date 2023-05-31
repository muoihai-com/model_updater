require 'model_updater/version'
require 'model_updater/engine'
require 'model_updater/diploma'

module ModelUpdater
  mattr_accessor :valid_models

  self.valid_models = %w[]

  def self.setup
    yield(self)
  end

  class InvalidModel < StandardError; end
end
