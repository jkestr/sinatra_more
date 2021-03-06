require 'sinatra/base'
require 'sinatra_more'
require 'haml'

class MarkupDemo < Sinatra::Base
  register SinatraMore::MarkupPlugin

  configure do
    set :root, File.dirname(__FILE__)
  end

  get '/:engine/:file' do
    show(params[:engine], params[:file].to_sym)
  end

  helpers do
    # show :erb, :index
    # show :haml, :index
    def show(kind, template)
      eval("#{kind.to_s} #{template.to_sym.inspect}")
    end

    def captured_content(&block)
      content_html = capture_html(&block)
      "<p>#{content_html}</p>"
    end

    def concat_in_p(content_html)
      concat_content "<p>#{content_html}</p>"
    end

    def ruby_not_template_block
      determine_block_is_template('ruby') do
        content_tag(:span, "This not a template block")
      end
    end

    def determine_block_is_template(name, &block)
      concat_content "<p class='is_template'>The #{name} block passed in is a template</p>" if block_is_template?(block)
    end
  end
end

class MarkupUser
  def errors; Errors.new; end
  def session_id; 45; end
  def gender; 'male'; end
  def remember_me; '1'; end
  def permission; Permission.new; end
end

class Permission
  def can_edit; true; end
  def can_delete; false; end
end

class Errors < Array
  def initialize; self << [:fake, :second, :third]; end
  def full_messages
    ["This is a fake error", "This is a second fake error", "This is a third fake error"]
  end
end

module Outer
  class UserAccount; end
end