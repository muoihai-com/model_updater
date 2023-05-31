# frozen_string_literal: true

Dir.glob("#{__dir__}/model_updater/*.rb").sort.each do |file|
  require file
end

module ModelUpdater
  mattr_accessor :valid_models

  self.valid_models = %w[]

  def self.setup
    yield(self)
  end

  class InvalidModel < StandardError; end
end
