class ItemRequestController < ApplicationController

  def index
    @requests = ItemRequest.all
  end
end
