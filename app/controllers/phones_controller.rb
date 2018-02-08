class PhonesController < ApplicationController
  def destroy
    phone = Phone.find params[:id]
    phone.delete
  end
end
