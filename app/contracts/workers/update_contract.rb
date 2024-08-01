module Workers
  class UpdateContract < ApplicationContract
    json do
      optional(:name).maybe(:string)
    end
  end
end
