class PagesController < ApplicationController
  allow_unauthenticated_access

  def terms; end
  def privacy; end
  def cookie_policy; end
  def community; end
  def responsible_drinking; end
  def help; end
end
