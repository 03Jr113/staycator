class Users::HomesController < ApplicationController

  def top
    @reviews = Review.all
  end

  def about
  end

end