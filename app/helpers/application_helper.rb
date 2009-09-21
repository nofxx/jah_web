# -*- coding: utf-8 -*-
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def input(i, label)
    "<li> #{label}: #{i} </li>"
  end


 def display_flashes
    flashes = ''
    unless flash.size == 0
      flash.each_pair  do |key, value|
        flashes += content_tag(:div, content_tag(:div, value, :class => 'message '+key.to_s), :class => 'flash')
      end
    end
    flashes
  end

  def sidebar(&block)
    content_for :sidebar do
      concat "<div class='block'><h3>Menu</h3><ul class='navigation'>"
      yield
      concat '</ul></div>'
    end
  end

  def yn(bool)
    bool ? "Sim" : "Não"
  end

  def link_or_nil(obj, *args)
    opts = { :link_text => obj, :url => obj, :text => '-' }.update( args.extract_options! )
    if obj
      link_to((opts[:link_text_method] ? obj.send(opts[:link_text_method]) : opts[:link_text]), opts[:url])
    else
      opts[:text]
    end
  end

  def back_link(txt = "Voltar")
    link_to txt, { :controller => controller.controller_name, :action => :index } , :class => 'icon back'
  end

  def edit_link(id=nil, txt = "Editar")
    if id
      id = id.id unless id.is_a? Integer
      link_to txt, { :controller => controller.controller_name, :action => :edit, :id => id }, :class => 'icon edit'
    else
      link_to txt, { :controller => controller.controller_name, :action => :edit }, :class => 'icon edit'
    end
  end

  def destroy_link(id = nil, txt = "Excluir")
    if id
      id = id.id unless id.is_a? Integer
      link_to txt, { :controller => controller.controller_name, :action => :destroy, :id => id }, :class => 'icon destroy', :method => :delete
    else
      link_to txt, { :controller => controller.controller_name, :action => :destroy }, :class => 'icon destroy', :method => :delete
    end
  end

  def save_or_cancel(f)
    out = "<div class='clear'></div><div class='navform'>"
    out += f.submit "Gravar"
    out += "ou"
    link = url_for(:controller => controller.controller_name, :action => :index) rescue "/"
    out += link_to "cancelar", link
    out += "</div>"
  end

  def count_as_text(num, one, more, zero = nil)

    out = case num
    when 0; zero || one;
    when 1; one;
    else more;
    end
    out % num
  end

  def search(*args)
    opts = { :controller => controller.controller_name, :action => :index, :msg => "", :forceMsg => false, :searchInUrl => false }.
      update(args.extract_options!)
    url = opts.delete :url || url_for(:controller => opts[:controller], :action => opts[:action])
    opts[:msg] = params[:search] if not params[:search].nil? and not params[:search].empty? and opts[:forceMsg] == false

    out  = "<div class='block'><h3>Busca</h3>"
    out += "<form method='GET' action='#{url}' class='search' id='sidebar_search'>"
    out += "<input type='text' value='#{h(opts[:msg])}' id='search' name='search' />"
    out += '<input type="submit" value="" id="searchbutton" class="icons" />'
    out += '</form>'
    out += javascript_tag "$('input#search').textmask()" unless opts[:msg].empty?
    out += javascript_tag "$('form#sidebar_search').searchInUrl('input#search');" if opts[:searchInUrl]
    out += "</div>"
  end

  def mark_search(name, *opts)
    opts = { :search => params[:search] }.update(opts.extract_options!)
    name = h(name)
    return name if not opts[:search].is_a?(String) or opts[:search].size <= 0
    name.gsub(/(#{opts[:search]})/i, '<strong class="mark_search">\1</strong>')
  end


  def show_for(what, fields=nil)
    #raise ArgumentError, "Missing block" unless block_given?
    if fields
      fields.inject("") do |out, field|
        out << "<p><b>#{I18n.t('activerecord.attributes.' + what.class.to_s.downcase + "." + field.to_s, :default => field.to_s.capitalize)}:</b> #{what.send(field)}</p>"
      end
    else
      "<p><b>#{what}</b></p>"
    end
    #concat  yield self
    #"#{what} #{block.call what}" #"#{what.class}: #{yield what}" #"dd" #what.to_s #
    #out << block #{ |w| w ? "<b>#{I18n.t(what)}:</b>#{what}-#{w}" : nil}.call(what)
   # out
  end

  def link_to_map(obj, label=false)
    link_to label ? "Ver no mapa" :  "", "/map##{obj.class.table_name}/#{obj.id}", :class => "icon map"
  end

  def date_or_text(date, *args)
    opts = { :text => 'Sem data' }.update( args.extract_options! )
    if date
      l(date, :format => opts[:format])
    else
      opts[:text]
    end
  end

  def show_links
      [
        back_link,
        edit_link,
        destroy_link
      ].join(' | ')
  end

end
