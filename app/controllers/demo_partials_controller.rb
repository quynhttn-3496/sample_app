class DemoPartialsController < ApplicationController
  def new
    @zone = "Zone new action"
    @date = Time.zone.today
  end

  def edit
    @zone = "Zone edit aciton"
    @date = Time.zone.today - 4
  end
end
