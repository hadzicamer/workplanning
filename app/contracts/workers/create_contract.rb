module Workers
  class CreateContract < ApplicationContract
    json do
      optional(:name).maybe(:string)
    end
  end
end
