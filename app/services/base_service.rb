# frozen_string_literal: true

# BaseService
module BaseService
  extend ActiveSupport::Concern

  class_methods do
    def call(*args)
      new(*args).call
    end
  end
end
