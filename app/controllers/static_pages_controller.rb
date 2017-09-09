class StaticPagesController < ApplicationController

  def home
  end

  private

  def google
    @google ||= GoogleClient.new
  end

end
