module MsTools
  module ApplicationHelpers

    # Outputs the corresponding flash message if any are set
    #
    # This function is used to output the flash messages in a nice formated
    # way. It is typically used in the application layout.
    #
    def flash_messages
      messages = []
      %w(notice warning).each do |msg|
        messages << content_tag(:div, flash[msg.to_sym], :id => "flash-#{msg}") unless flash[msg.to_sym].blank?
      end
      if flash[:error].is_a?( Hash)
        flash_to_display << activerecord_error_list(flash[:error])
      else
        flash_to_display = flash[:error]
      end
      messages << content_tag(:div, flash_to_display, :id => "flash-error") unless flash_to_display.blank?
      raw(messages)
    end

    # Normalizes image file names
    #
    # This function tries to find the file based on the name supplied. In
    # normal use you will only need to supply the image file name without
    # any extention. It will check for the supplied name as is, and with
    # .png, .gif, or .jpg extentions added to the supplied name, in the
    # public, public/images, and public/images/icons directories. If the
    # file is found, it's normalized path name is returned. Note: It will
    # also match any file that is explictly specified.
    #
    def clean_imagefile_name(name='')
      root = Rails.public_path
      filename = ""
      # Shortcut to handle the most common cases.
      if FileTest.exist?( File.join( root, "/images/#{name}.png" ) )
        filename = "/images/#{name}.png"
      elsif FileTest.exist?( File.join( root, "/images/icons/#{name}.png" ) )
        filename = "/images/icons/#{name}.png"
      else
        # If not, check all
        ["", ".png", ".gif", ".jpg"].each do |ext|
          # Check if full path has been specified
          if FileTest.exist?( File.join( root, name + ext ) )
            filename = name + ext
          elsif FileTest.exist?( File.join( root, "/images/", name + ext ) )
            filename = File.join( "/images/", name + ext )
          elsif FileTest.exist?( File.join( root, "/images/icons/", name + ext ) )
            filename = File.join( "/images/icons/", name + ext )
          end
        end
      end
      if filename.blank?
        filename = "/images/broken.png"
      end
      filename
    end

    # Formats a "command_button" class link
    #
    # This function creates a link with an embedded image along with text. The
    # link has a class of "command_button" added to it. It is expected that the
    # "command_button" class will be formatted to resemble a button.
    #
    def command_button(text='', image='', url='', permission=nil, options = {})
      options.stringify_keys!
      text     = text.blank? ? ""  : text
      img_tag  = image_tag(clean_imagefile_name(image), :class=>"edit_icon", :alt=>" &raquo; ", :title=>text)
      url      = url.blank? ? "#" : url
      options['class'] = options.has_key?('class') ? options['class'] + " command_button" : "command_button"

      if permission.nil? || permission
        link_to( img_tag + text, url, options )
      end
    end

    # Formats a "menu_icon" class link
    #
    # This function creates a link with an embedded image along with text. The
    # image has a class of "menu_icon" added to it. It is expected that the
    # "menu_icon" class will be formatted to resemble a button.
    #
    def image_button(text='', image='', url='', permission=nil, options = {})
      options.stringify_keys!
      text    = text.blank?  ? ""  : text
      img_tag = image_tag(clean_imagefile_name(image), :class => 'menu_icon', :alt=>" &raquo; ", :title=>text)
      url     = url.blank?   ? "#" : url

      if permission.nil? || permission
        link_to( img_tag + text, url, options )
      end
    end

  private

    def activerecord_error_list(errors)
      error_list = '<ul class="error_list">'
      error_list << errors.collect do |e, m|
        "<li>#{e.humanize unless e == "base"} #{m}</li>"
      end.to_s << '</ul>'
      error_list
    end

  end
end

ActionView::Base.send :include, MsTools::ApplicationHelpers
